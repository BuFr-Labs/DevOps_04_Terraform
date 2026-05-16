# DevOps_04_Terraform
Repozitoř k 4. lekci

# DevOps Úkol 04: Infrastruktura jako kód (IaC) pomocí Terraformu

Tento repozitář obsahuje řešení domácího úkolu zaměřeného na automatizaci nasazení cloudové infrastruktury v AWS pomocí nástroje Terraform.

## 🎯 Cíle projektu
* Automatické vytvoření EC2 instance v AWS.
* Dynamické vyhledání nejnovějšího obrazu (AMI) pro Amazon Linux 2023.
* Konfigurace bezpečnostní skupiny (Security Group) pro povolení SSH přístupu.
* Bezpečné předání veřejného SSH klíče na server.
* Zajištění čistého stavu repozitáře (ignorování citlivých dat a stavových souborů pomocí `.gitignore`).

## 📂 Struktura projektu
Projekt je rozdělen do logických bloků podle "Best Practices" pro Terraform:

* `main.tf` - Hlavní definiční soubor (konfigurace AWS providera, vyhledání AMI pomocí `data` bloku, definice `aws_security_group`, `aws_key_pair` a `aws_instance`).
* `variables.tf` - Definice proměnných pro snadnou znovupoužitelnost kódu (AWS region, typ instance `t3.micro`).
* `outputs.tf` - Definice výstupů po úspěšném nasazení (vypsání veřejné IP adresy a vygenerování přesného příkazu pro SSH připojení).

## 🚀 Návod k použití

### 1. Prerekvizity
* Nainstalované a nakonfigurované **AWS CLI** (`aws configure`).
* Nainstalovaný **Terraform**.
* Lokálně vygenerovaný SSH klíč (např. `id_ed25519`).

### 2. Spuštění
Inicializace Terraformu a stažení AWS providera:
```bash
terraform init
```

Náhled plánovaných změn v infrastruktuře:
```Bash
terraform plan
```

Nasazení infrastruktury do AWS:
```Bash
terraform apply
```

### 3. Ověření připojení
Po úspěšném nasazení Terraform vypíše příkaz pro SSH připojení. Připojení na vygenerovaný server:
```Bash
ssh -i ./id_ed25519 ec2-user@<vygenerovana-verejna-ip>
```

### 4. Úklid infrastruktury (Cleanup)
Pro zamezení zbytečných nákladů v AWS je nutné po otestování infrastrukturu smazat:
```Bash
terraform destroy
```

### Bezpečnost
Privátní SSH klíče (*.pem, id_*) a stavové soubory Terraformu (*.tfstate) jsou záměrně ignorovány v souboru .gitignore, aby nedošlo k úniku citlivých dat do veřejného repozitáře.


