provider "aws" {
    region = "us-east-1"
}

provider "vault" {
    address = "http://3.237.33.244:8200"
    skip_child_token = true // Authenticcation will fail if u dont pt this

    auth_login { // How u want to login
        path = "auth/approle/login" //

        parameters = {
          role_id = "f15ca5d8-09d0-0247-48f4-e68dca337a08"
          secret_id = "e1025818-b62b-77c6-0d46-ed7a42be3766" 
        }
    }
}

// to put resources in the vault {creeate infrastructure}
# resource "" "name" {
  
# }

// to get data or resources form the vault {to retrieve data}
data "vault_kv_secret_v2" "example" {
  mount = "kv1"
  name  = "test-secret"
}

resource "aws_instance" "example1" {
    ami = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
    tags = {
        secret = data.vault_kv_secret_v2.example.data["username"] // it wiill return a key value pair
      Name = "AWS Instance"
    }
}