# -*- mode: ruby -*-
# vi: set ft=ruby :


BALANCER1_SETUP = <<EOF.freeze
yum update -y && yum install -y haproxy
cat /vagrant/balancer-1.pem /vagrant/balancer-1-key.pem > /etc/pki/tls/private/haproxy.pem
cp -fv /vagrant/ca.pem /etc/pki/tls/certs/
cp -fv /vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg
systemctl enable haproxy
sleep 10 && systemctl start haproxy
EOF

WEB1_SETUP = <<EOF.freeze
yum update -y && yum install -y httpd mod_ssl
cp -fv /vagrant/web-1.pem /etc/pki/tls/certs/localhost.crt
cp -fv /vagrant/web-1-key.pem /etc/pki/tls/private/localhost.key
cp -fv /vagrant/ca.pem /etc/pki/tls/certs/
cat > /var/www/html/index.html << __END__
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>$(hostname)</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h1>Greetings!</h1>
    <p>From $(hostname)</p>
  </body>
</html>
__END__
systemctl enable httpd
systemctl start httpd
EOF

WEB2_SETUP = <<EOF.freeze
yum update -y && yum install -y httpd mod_ssl
cp -fv /vagrant/web-2.pem /etc/pki/tls/certs/localhost.crt
cp -fv /vagrant/web-2-key.pem /etc/pki/tls/private/localhost.key
cp -fv /vagrant/ca.pem /etc/pki/tls/certs/
cat > /var/www/html/index.html << __END__
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>$(hostname)</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h1>Greetings!</h1>
    <p>From $(hostname)</p>
  </body>
</html>
__END__
systemctl enable httpd
systemctl start httpd
EOF

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.provider :libvirt do |domain|
    domain.graphics_type = 'none'
    domain.graphics_ip = nil
    domain.graphics_port = nil
    domain.video_type = nil
    domain.video_vram = 0
    domain.memory = 512
    domain.cpus = 1
    domain.random model: 'random'
  end
  # config.vm.synced_folder '.', '/vagrant', disabled: true
  %w[balancer-1 web-1 web-2].each do |vm_name|
    config.vm.define vm_name do |machine|
      machine.vm.hostname = vm_name
      if Vagrant.has_plugin?('vagrant-cachier')
        config.cache.scope = :box
      end
    end
  end
  config.vm.define 'balancer-1' do |machine|
    machine.vm.provision 'shell', inline: BALANCER1_SETUP.dup
  end
  config.vm.define 'web-1' do |machine|
    machine.vm.provision 'shell', inline: WEB1_SETUP.dup
  end
  config.vm.define 'web-2' do |machine|
    machine.vm.provision 'shell', inline: WEB2_SETUP.dup
  end
end
