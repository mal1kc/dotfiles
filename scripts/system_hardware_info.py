import psutil
import platform
from datetime import datetime


def get_size(bytes, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"
        bytes /= factor


# =*20 , System information , =*20
print('='*20, 'system information', '='*20)
uname = platform.uname()
print(f" system: {uname.system}")
print(f" node name: {uname.node}")
print(f" relase: {uname.release}")
print(f" version: {uname.version}")
print(f" machine: {uname.machine}")
print(f" processor: {uname.processor}")

# \n, =*25, Boot Time, =*25, \n

print('='*25, 'boot time', '='*25)
bt = datetime.fromtimestamp(psutil.boot_time())
print(
    f' boot time: {bt.day}/{bt.month}/{bt.year} - {bt.hour}:{bt.minute}:{bt.second}')

# Cpu information
print('='*22, 'cpu information', '='*22)

print('', '-', 'number of cores', '-')
print(f' pyhsical cores: {psutil.cpu_count(logical=False)}')
print(f' total cores: {psutil.cpu_count(logical=True)}')

print('', '-', 'cpu frequencies', '-')
cpufreq = psutil.cpu_freq()
print(f' max frequency: {cpufreq.max:.2f}Mhz')
print(f' min frequency: {cpufreq.min:.2f}Mhz')
print(f' current frequency: {cpufreq.current:.2f}Mhz')

print('', '-', 'cpu usage', '-') 
print(' cpu usage per core: ') 
for i, percentage in enumerate(psutil.cpu_percent(percpu=True,interval=1)):
    print(f'   core {i}: {percentage}%')
print(f' total cpu usage: {psutil.cpu_percent()}%')

# memory information
print('='*20, 'memory information', '='*20)

svmem = psutil.virtual_memory()
print(f' total: {get_size(svmem.total)}')
print(f' available: {get_size(svmem.available)}')
print(f' used: {get_size(svmem.used)}')
print(f' percentage: {svmem.percent}%')

print('-'*10,'swap memory','-'*10)
swap = psutil.swap_memory()
print(f" total: {get_size(swap.total)}")
print(f" free: {get_size(swap.free)}")
print(f" used: {get_size(swap.used)}")
print(f" percentage: {swap.percent}%")

#disk info
print('='*21, 'disk information', '='*21)
print(' partitions and usage :')
for partition in psutil.disk_partitions():
    print(f' --> device: {partition.device}')
    print(' '*3, f'mount point: {partition.mountpoint}')
    print(' '*3, f'file system type: {partition.fstype}')
    try:
        partition_usage = psutil.disk_usage(partition.mountpoint)
    except PermissionError:
        # this can be catched due to the disk that
        # isn't ready
        continue
    print(' '*3, f'total size: {get_size(partition_usage.total)}')
    print(' '*3, f'used size: {get_size(partition_usage.used)}')
    print(' '*3, f'free size: {get_size(partition_usage.free)}')
    print(' '*3, f'percentage: {partition_usage.percent}%')

# get I/O statistics since boot
disk_io = psutil.disk_io_counters()
print(' I/O statistics since boot:')
print(f'  -> total read: {get_size(disk_io.read_bytes)}')
print(f'  -> total write: {get_size(disk_io.write_bytes)}')

# network info
print('='*19, 'network information', '='*19)
# get all network interfaces (virtual & pyhsical)
for interface_name, interface_adresses in psutil.net_if_addrs().items():
    for address in interface_adresses:
        if str(address.family) == 'AddressFamily.AF_INET':
            if(address.address):
                print(f' ---> interface: {interface_name} <---')
                print(f"  ip address: {address.address}")
                print(f"  netmask: {address.netmask}")
                print(f"  broadcast ip: {address.broadcast}")
        elif str(address.family) == 'AddressFamily.AF_PACKET':
            if(address.address):
                print(f' ---> interface: {interface_name} <---')
                print(f"  mac address: {address.address}")
                print(f"  netmask: {address.netmask}")
                print(f"  broadcast mac: {address.broadcast}")

# get I/O statics since boot
net_io = psutil.net_io_counters()
print('-'*20,f"\n total bytes sent: {get_size(net_io.bytes_sent)}")
print(f" total bytes received: {get_size(net_io.bytes_recv)}")