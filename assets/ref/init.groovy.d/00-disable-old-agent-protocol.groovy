#!groovy

// imports
import java.util.logging.Logger
import jenkins.security.s2m.*
import jenkins.model.Jenkins

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
Logger logger = Logger.getLogger("dsuite/jenkins")

logger.info("disabling old Non-Encrypted protocols")

// Remove Non-Encrypted protocols
HashSet<String> newProtocols = new HashSet<>(jenkins.getAgentProtocols());
newProtocols.removeAll(Arrays.asList(
    "JNLP3-connect", "JNLP2-connect", "JNLP-connect", "CLI-connect"
));

// Disable old Non-Encrypted protocols
jenkins.setAgentProtocols(newProtocols);

// save current Jenkins state to disk
jenkins.save()
