require('dotenv').config();
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

transporter.sendMail({
  from: `"MotMotMind" <${process.env.EMAIL_USER}>`,
  to: ['asta24268@gmail.com', 'neethisharma.motmotmind@gmail.com'],
  subject: 'Test Email',
  text: 'If you see this, your email setup works!'
}).then(() => {
  console.log('✅ Email sent');
}).catch(err => {
  console.error('❌ Email failed:', err);
});
