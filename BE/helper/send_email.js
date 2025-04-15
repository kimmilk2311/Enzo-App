const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
require('dotenv').config();

const client = new SESClient({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

// Hàm tạo nội dung HTML email xác thực
const generateOtpVerificationEmailHtml = (otp) => {
  const appName = process.env.APP_NAME;

  return `
    <html>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; background-color: #f9f9f9; padding: 20px;">
        <div style="max-width: 600px; margin: auto; background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
          <h2 style="color: #333;">Chào  bạn,</h2>
          <p>Bạn đã yêu cầu xác minh tài khoản tại <strong>${appName}</strong>.</p>
          <p>Mã xác thực (OTP) của bạn là:</p>
          <div style="font-size: 24px; font-weight: bold; text-align: center; margin: 20px 0; color: #007bff;">
            ${otp}
          </div>
          <p><strong>Lưu ý:</strong> Mã có hiệu lực trong vòng <strong>10 phút</strong> kể từ thời điểm nhận email này.</p>
          <p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>
          <p>Trân trọng,<br><strong>Đội ngũ ${appName}</strong></p>
        </div>
      </body>
    </html>
  `;
};

// Hàm gửi email xác thực
const sendOtpEmail = async (email, otp) => {
  const params = {
    Source: process.env.EMAIL_FROM,
    ReplyToAddresses: [process.env.EMAIL_TO],

    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Body: {
        Html: {
          Charset: "UTF-8",
          Data: generateOtpVerificationEmailHtml(otp), 
        },
      },
      Subject: {
        Charset: "UTF-8",
        Data: `Chào mừng đến với ${process.env.APP_NAME}`,
      },
    },
  };

  const command = new SendEmailCommand(params);

  try {
    const data = await client.send(command);
    return data;
  } catch (error) {
    console.error("Error sending email:", error);
    throw new Error("Gửi email thất bại");
  }
};

module.exports = sendOtpEmail;
