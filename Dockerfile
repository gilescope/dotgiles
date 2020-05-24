FROM centos-vnc
#FROM consol/centos-xfce-vnc
ENV REFRESHED_AT 2018-03-18
	
# Register the Microsoft RedHat repository
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo

# Install PowerShell
RUN yum install -y powershell

COPY pwsh_configure.ps1 pwsh_configure.ps1 
RUN pwsh ./pwsh_configure.ps1
SHELL ["pwsh"]
