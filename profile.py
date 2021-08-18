"""This profile sets up a simple NFS server and a network of clients. The NFS server uses
a long term dataset that is persistent across experiments. In order to use this profile,
you will need to create your own dataset and use that instead of the demonstration 
dataset below. If you do not need persistant storage, we have another profile that
uses temporary storage (removed when your experiment ends) that you can use. 

Instructions:
Click on any node in the topology and choose the `shell` menu item. Your shared NFS directory is mounted at `/nfs` on all nodes."""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Only Ubuntu images supported.
imageList = [
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD', 'UBUNTU 20.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD', 'UBUNTU 18.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU16-64-STD', 'UBUNTU 16.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS7-64-STD', 'CENTOS 7'),
]

# Do not change these unless you change the setup scripts too.
nfsServerName = "nfs"
nfsLanName    = "nfsLan"
nfsDirectory  = "/nfs"

# Number of NFS clients (there is always a server)
pc.defineParameter("clientCount", "Number of NFS clients",
                   portal.ParameterType.INTEGER, 2)

pc.defineParameter("dataset", "Your dataset URN",
                   portal.ParameterType.STRING,
                   "urn:publicid:IDN+utah.cloudlab.us:mind-disagg-pg0+stdataset+mind_memory_accesses")

pc.defineParameter("osImage", "Select OS image",
                   portal.ParameterType.IMAGE,
                   imageList[1], imageList)

pc.defineParameter("localStorageSize", "local storage size",
                   portal.ParameterType.STRING, "0")

pc.defineParameter("phystype", "Switch type",
                   portal.ParameterType.STRING, "mlnx-sn2410",
                   [('mlnx-sn2410', 'Mellanox SN2410'),
                    ('dell-s4048',  'Dell S4048')])

pc.defineParameter("MINDNet", "mind network",
                   portal.ParameterType.STRING, "10.10.10.1")

pc.defineParameter("MINDNetMask", "mind network mask",
                   portal.ParameterType.STRING, "255.255.255.0")

# Always need this when using parameters
params = pc.bindParameters()

################################################################## NFS for remote dataset #####################
# The NFS network. All these options are required.
nfsLan = request.LAN(nfsLanName)
nfsLan.best_effort       = True
nfsLan.vlan_tagging      = True
nfsLan.link_multiplexing = True
# The NFS server.
nfsServer = request.RawPC(nfsServerName)
nfsServer.disk_image = params.osImage
# Attach server to lan.
nfsLan.addInterface(nfsServer.addInterface())
# Initialization script for the server
nfsServer.addService(pg.Execute(shell="sh", command="sudo /bin/bash /local/repository/nfs-server.sh"))
'''
# Special node that represents the ISCSI device where the dataset resides
dsnode = request.RemoteBlockstore("dsnode", nfsDirectory)
dsnode.dataset = params.dataset

# Link between the nfsServer and the ISCSI device that holds the dataset
dslink = request.Link("dslink")
dslink.addInterface(dsnode.interface)
dslink.addInterface(nfsServer.addInterface())
# Special attributes for this link that we must use.
dslink.best_effort = True
dslink.vlan_tagging = True
dslink.link_multiplexing = True
################################################################## NFS for remote dataset #####################
'''

################################################################## MIND Net ###################################
MINDsw = request.Switch("MINDsw");
MINDsw.hardware_type = params.phystype
################################################################## MIND Net ###################################


# The NFS clients, also attached to the NFS lan.
for i in range(1, params.clientCount+1):
    node = request.RawPC("node%d" % i)
    '''
    node.hardware_type = 'c6525-100g'
    node.disk_image = params.osImage
    mybs = node.Blockstore("mybs%d" % i, "/mydata")
    mybs.size = params.localStorageSize
    nfsLan.addInterface(node.addInterface())
    '''
    
    #mind net
    MINDswiface = MINDsw.addInterface()
    MINDnodeiface = node.addInterface()
    iparr = list(params.MINDNet.split("."))
    iparr[-1] = str(int(iparr[-1]) + i)
    ipstr = ".".join(iparr)
    MINDnodeiface.addAddress(pg.IPv4Address(ipstr, params.MINDNetMask))
    MINDlink = request.L1Link("MINDlink%d" % i)
    MINDlink.addInterface(MINDnodeiface)
    MINDlink.addInterface(MINDswiface)
    
    # Initialization script for the clients
    '''
    node.addService(pg.Execute(shell="sh", command="sudo /bin/bash /local/repository/nfs-client.sh"))
    '''
    pass

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
