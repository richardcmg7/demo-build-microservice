// Script de inicialización para Jenkins
import jenkins.model.*
import hudson.security.*
import hudson.slaves.*
import hudson.slaves.JNLPLauncher
import hudson.model.*
import java.io.File

def instance = Jenkins.getInstance()

// Configurar usuario admin por defecto
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Configurar el slave automáticamente
def agentName = "jenkins-slave"
def agentDescription = "Jenkins Slave para builds de Java/Maven"
def agentRemoteFS = "/home/jenkins/agent"
def agentLabels = "java maven docker linux"

def launcher = new JNLPLauncher(true)
def agent = new DumbSlave(
    agentName,
    agentDescription,
    agentRemoteFS,
    "2", // número de ejecutores
    Node.Mode.NORMAL,
    agentLabels,
    launcher,
    new RetentionStrategy.Always(),
    new LinkedList()
)

instance.addNode(agent)

// Generar el token del slave y guardarlo en un archivo
def computer = agent.toComputer()
def jnlpMac = computer.getJnlpMac()

// Guardar el token en un archivo compartido para que el slave lo pueda leer
def tokenFile = new File("/shared/slave-token.txt")
tokenFile.text = jnlpMac
// Dar permisos de lectura a todos
tokenFile.setReadable(true, false)

instance.save()

println "Jenkins configurado con usuario admin/admin123"
println "Slave '${agentName}' agregado automáticamente"
println "Token del slave guardado en: /shared/slave-token.txt"
println "Java 21 y Maven ya están disponibles en el slave"
println "IMPORTANTE: Configurar credenciales de Docker Hub manualmente en Jenkins"