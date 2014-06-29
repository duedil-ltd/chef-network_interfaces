
include_recipe "network_interfaces::default"

node[:network_interfaces][:add_interfaces].each do |device,config|
  network_interfaces device do
    onboot true
    target config[:address]
    mask config[:netmask]
    broadcast config[:broadcast]
    post_up [
        "echo 200 chef >> /etc/iproute2/rt_tables",
        "ip rule add from #{config[:address]} table chef",
        "ip route add default via #{config[:gateway]} dev #{device} table chef"
    ]
    pre_down [
        "sed -i 's/^200 chef.*//g' /etc/iproute2/rt_tables"
    ]
  end
end
