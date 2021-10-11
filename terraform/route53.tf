resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = "dev.seanspradlin.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}