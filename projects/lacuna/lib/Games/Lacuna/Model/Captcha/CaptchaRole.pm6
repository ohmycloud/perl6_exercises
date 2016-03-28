
role Games::Lacuna::Model::Captcha::CaptchaRole {
    use URI;

    has Str $.guid;
    has URI $.image_url;
    has Buf $.image_content;
}

