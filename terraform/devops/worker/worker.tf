
provider "google" {
  credentials = "${file("/home/dario_pasquali93/.config/gcloud/terraform-admin.json")}"
  project     = "mondadorici"
  region      = "us-east1-b"
}

resource "google_compute_instance" "worker" {
 project = "mondadorici"
 zone = "us-east1-b"
 name = "tf-worker"
 machine_type = "n1-standard-2"

 tags = ["jenkins", "cloudera", "http", "https"]
 
 boot_disk {
   initialize_params {
     image = "centos-7-v20171213"
     size = "30"
   }
 }
 
 network_interface {
   network = "default"
   access_config {
   }
 }

 provisioner "local-exec" {
 
  command = "sleep 90; ansible-playbook -i '${google_compute_instance.worker.name},' --private-key=~/.ssh/ansible_rsa /opt/ansible/worker.yml -e 'ansible_ssh_user=dario_pasquali93' -e 'host_key_checking=False'"
 }
}

output "worker" {
 value = "${google_compute_instance.worker.self_link}"
}

