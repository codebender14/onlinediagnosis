const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

exports.sendEmail = functions.https.onRequest((req, res) => {
  const {subject, loginMail, emailFrom, emailTo, appPassword, body} = req.body;
  const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    requireTLS: true,
    auth: {
      user: loginMail,
      pass: appPassword,
    },
  });

  const mailOptions = {
    from: emailFrom,
    to: emailTo,
    subject: subject,
    html: body,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      res.status(500).send("Error sending email");
    } else {
      console.log("Email sent: " + info.response);
      res.send("Success");
    }
  });
});
