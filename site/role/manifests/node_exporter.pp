
# This class is ment for all the node_exporter.
# So they can send data to the prometheus server aka the manager.borg.trek
class role::node_exporter {
    include profile::nodes
}

