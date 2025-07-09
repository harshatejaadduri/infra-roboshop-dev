
      sudo growpart /dev/nvme0n1 4
      sudo lvextend -L +14G /dev/RootVG/rootVol
      sudo lvextend -L +16G /dev/mapper/RootVG-homeVol
      sudo xfs_growfs /
      sudo xfs_growfs /home 
      
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
      sudo yum -y install terraform

      if [ ! -d "infra-roboshop-dev" ]; 
      then git clone https://github.com/harshatejaadduri/infra-roboshop-dev.git 
      else echo "Repo already exists. Skipping clone"
      fi

      