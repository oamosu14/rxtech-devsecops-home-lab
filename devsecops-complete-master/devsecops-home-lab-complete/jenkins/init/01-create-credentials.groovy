import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import hudson.util.Secret

def instance = Jenkins.getInstance()

def domain = Domain.global()
def creds_store = instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Harbor robot credential (username/password)
def secret = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  "harbor-robot", "Harbor robot account", "robot$jenkins", "REPLACE_WITH_REAL_PASSWORD"
)
creds_store.addCredentials(domain, secret)
println("Added harbor-robot credential (id=harbor-robot)")
