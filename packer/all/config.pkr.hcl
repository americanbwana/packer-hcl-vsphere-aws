packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
    windows-update = {
    version = "0.14.0"
    source = "github.com/rgl/windows-update"
    }
  }
}