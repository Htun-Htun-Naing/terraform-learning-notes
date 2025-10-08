
resource "docker_container" "php-httpd" {
  name  = "webserver"
  hostname = "php-httpd"
  networks = [docker_network.private_network.name]
  image = docker_image.php-httpd-image.latest
  labels {
     label = "challenge"
     value = "second"
    }
  ports {
    internal = 80
    external = 80
    ip      = "0.0.0.0"
  }
  volumes {
    host_path      = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    container_path = "/var/www/html"
  }
}

resource "docker_container" "mariadb" {
  name  = "db"
  hostname = "db"
  networks = [docker_network.private_network.name]
  labels {
     label = "challenge"
     value = "second"
    }
  ports {
    internal = 3306
    external = 3306
    ip      = "0.0.0.0"
  }
  env = ["MYSQL_ROOT_PASSWORD=1234", "MYSQL_DATABASE=simple-website"]
  volumes {
    volume_name    = docker_volume.mariadb_volume.name
    container_path = "/var/lib/mysql"
  }
  image = docker_image.mariadb-image.latest
}

resource "docker_container" "phpmyadmin" {
  name  = "db_dashboard"
  hostname = "phpmyadmin"
  networks = [docker_network.private_network.name]
  labels {
     label = "challenge"
     value = "second"
    }
  ports {
    internal = 8081
    external = 8081
    ip      = "0.0.0.0"
  }

  image = "phpmyadmin/phpmyadmin:latest"
  links = [docker_container.mariadb.name]
  depends_on = [ docker_container.mariadb ]
}