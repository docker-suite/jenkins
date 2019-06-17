#!groovy

import jenkins.model.*
import hudson.security.*

def env = System.getenv()
def jenkins = Jenkins.getInstance()

// First check if security is enable
if(jenkins.getAuthorizationStrategy() == null) { return; }
// Check if the strategy depend on matrix-auth
if(!(jenkins.getAuthorizationStrategy() instanceof GlobalMatrixAuthorizationStrategy)) { return; }

// Admin user and password must be declared
if(env.JENKINS_ADMIN_USER == null || env.JENKINS_ADMIN_PASS == null) { return; }

// Get list or current users
def currentUsers = jenkins.getSecurityRealm().getAllUsers().collect { it.getId() }

// Create default admin user if not exists.
if(!(env.JENKINS_ADMIN_USER in currentUsers)) {
    // Create user
    def hudsonRealm = jenkins.getSecurityRealm()
    hudsonRealm.createAccount(env.JENKINS_ADMIN_USER, env.JENKINS_ADMIN_PASS)
    jenkins.setSecurityRealm(hudsonRealm)
    // Set user as admin
    def strategy = jenkins.getAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, env.JENKINS_ADMIN_USER)
    jenkins.setAuthorizationStrategy(strategy)
    // Save
    jenkins.save()
}
