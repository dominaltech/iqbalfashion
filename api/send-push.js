// Vercel Serverless Function to Send Encrypted Web Push Notifications to Admin PWA — Iqbal Fashion
const webpush = require('web-push');

const recentPushes = global.__recentPushes || (global.__recentPushes = new Map());

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  const vapidSubject = process.env.VAPID_SUBJECT || "mailto:iqbalfashiongents@gmail.com";
  const vapidPublicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY || "BF3kSJsLXqbdtvzEQewSqxomcxnyvbse1p2M6fGn8x-tIzy_HpANDKK6AeHoafBz6Gx0EHGWF2MaOuC2jg7pKCM";
  const vapidPrivateKey = process.env.VAPID_PRIVATE_KEY || "uhpnPsNgbA1cNt6kkNND0mLKMNzAlnPOPowST4H8KFE";

  webpush.setVapidDetails(vapidSubject, vapidPublicKey, vapidPrivateKey);

  try {
    const { title, message, order_id, amount, event_type } = req.body || {};
    const notifKey = `${order_id || 'general'}_${event_type || title || 'order'}`;
    const now = Date.now();

    // STRICT DEDUPLICATION: Prevent duplicate pushes for the same order event within 5 minutes
    if (order_id && recentPushes.has(notifKey)) {
      const lastSent = recentPushes.get(notifKey);
      if (now - lastSent < 300000) {
        console.log(`[Push Deduplicated] Push for ${notifKey} was already dispatched ${Math.round((now - lastSent)/1000)}s ago.`);
        return res.status(200).json({ success: true, count: 0, deduplicated: true, message: 'Notification already dispatched recently.' });
      }
    }
    recentPushes.set(notifKey, now);

    const payload = JSON.stringify({
      title: title || 'NEW IQBAL FASHION ORDER!',
      body: message || `Order #${order_id || ''} for ₹${amount || '0'} received!`,
      order_id: order_id || '',
      icon: '/images/logo.png',
      badge: '/images/logo.png'
    });

    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://yimbuvqtlbqdfggthaqt.supabase.co";
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpbWJ1dnF0bGJxZGZnZ3RoYXF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE2MzEyODEsImV4cCI6MjEwNzIwNzI4MX0.fnYjQ3mq13rkP-9sCyIsEt50Y5LQddwbGMtytJBajlU";

    const fetchRes = await fetch(`${supabaseUrl}/rest/v1/admin_push_subscriptions?select=*`, {
      headers: {
        'apikey': supabaseKey,
        'Authorization': `Bearer ${supabaseKey}`
      }
    });

    const subscriptions = await fetchRes.json();

    if (!subscriptions || !Array.isArray(subscriptions) || subscriptions.length === 0) {
      return res.status(200).json({ success: true, count: 0, message: 'No active admin push subscriptions registered.' });
    }

    const pushPromises = subscriptions.map(sub => {
      const pushConfig = {
        endpoint: sub.endpoint,
        keys: sub.keys
      };
      return webpush.sendNotification(pushConfig, payload).catch(err => {
        console.error('Failed push dispatch to endpoint:', sub.endpoint, err);
      });
    });

    await Promise.all(pushPromises);
    return res.status(200).json({ success: true, count: subscriptions.length });
  } catch (error) {
    console.error('Send push serverless error:', error);
    return res.status(500).json({ error: error.message });
  }
};
