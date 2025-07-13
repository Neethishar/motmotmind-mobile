const nodemailer = require('nodemailer');

// ✅ Log credentials in dev (optional)
if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
  console.warn("⚠️ EMAIL_USER or EMAIL_PASS is not set. Check your .env file.");
}

// ✅ Configure the email transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

/**
 * Sends an email with subject and text to a recipient
 * @param {string} to - Recipient's email address
 * @param {string} subject - Email subject line
 * @param {string} text - Email plain text content
 */
const sendEmail = async (to, subject, text) => {
  try {
    const info = await transporter.sendMail({
      from: `"MotMotMind" <${process.env.EMAIL_USER}>`,
      to,
      subject,
      text
    });
    console.log(`✅ Email sent to ${to}: ${info.response}`);
  } catch (error) {
    console.error('❌ Email sending failed:', error.message);
    throw error; // Let the caller handle the error
  }
};

module.exports = sendEmail;
