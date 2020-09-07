
data "template_file" "db-template" {
  template = file("dbconfig.tpl")

  vars = {
    db_host_name = aws_db_instance.orion-db.address
  }
}