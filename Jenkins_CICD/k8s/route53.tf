

data "external" "external_ip" {
  program = ["bash", "${path.module}/get_external_ip.sh"]
}

locals {
  defaults = ["bogreaper.me", "sock-shop"]
}

resource "aws_route53_zone" "domain" {
  name = local.defaults[0]

  tags = {
    Name = local.defaults[0]
  }
}

resource "aws_route53_record" "domain-route" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = "${local.defaults[1]}.${local.defaults[0]}"
  type    = "CNAME"
  ttl     = "300" 

  records = [data.external.external_ip.result["result"]]
}

