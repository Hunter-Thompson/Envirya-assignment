resource "aws_acm_certificate" "test" {
  domain_name       = "tester.expensebit.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb" "test" {
  name               = "helloworld-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]

  enable_deletion_protection = false

}



resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.test.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z3AYJUIAXBOLK2"
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.test.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = "Z3AYJUIAXBOLK2"
  name    = "tester.expensebit.com"
  type    = "A"

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_target_group" "test" {
  name     = "helloworld-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

}


resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.example.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.test.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}