# VADER - Advanced Nmap Command Builder Tool

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/License-Educational-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash-orange.svg" alt="Shell">
  <img src="https://img.shields.io/badge/Dependencies-nmap-red.svg" alt="Dependencies">
</p>

<p align="center">
  <strong>🚀 Revolutionizing Network Security Assessment Through Intelligent Automation</strong>
</p>

<p align="center">
  VADER transforms complex nmap operations into simple, guided workflows with real-time detection level awareness and educational components.
</p>

---

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Features](#-features)
- [🚀 Quick Start](#-quick-start)
- [📖 Usage Examples](#-usage-examples)
- [🛠️ Installation](#️-installation)
- [🎓 How It Works](#-how-it-works)
- [🔧 Command Reference](#-command-reference)
- [📊 Detection Level System](#-detection-level-system)
- [🎮 Interactive Features](#-interactive-features)
- [📚 Documentation](#-documentation)
- [🧪 Testing](#-testing)
- [🤝 Contributing](#-contributing)
- [⚖️ Legal & Ethics](#️-legal--ethics)
- [📄 License](#-license)

---

## 🎯 Overview

VADER (Version 1.0) is an intelligent, interactive command-line interface that makes nmap accessible to security professionals of all skill levels. Built for ethical hackers, penetration testers, and network administrators, VADER eliminates the steep learning curve of nmap while adding powerful features like detection level awareness and automated evasion techniques.

### The Problem
- **Complex Syntax**: nmap has 100+ flags that are difficult to memorize
- **Detection Risk**: No built-in awareness of scan detectability  
- **Time Consuming**: Building complex commands manually takes too long
- **Error Prone**: Easy to make syntax mistakes or use wrong flag combinations
- **Learning Curve**: New users struggle with nmap's complexity

### The Solution
VADER provides an intuitive, menu-driven interface that guides users through scan configuration, shows real-time detection feedback, and educates users about each technique's purpose and impact.

---

## ✨ Features

### 🎮 Interactive Design
- **Menu-driven interface** - No need to memorize complex syntax
- **Real-time command building** - See your nmap command as you build it
- **Contextual help** - Explanations and examples for every option
- **Smart input validation** - Prevents common mistakes and errors

### 🕵️ Detection Level Awareness
- **Unique 0-5 scale** showing how detectable your scans are
- **Visual feedback** - Real-time meter updates as you add techniques
- **Stealth optimization** - Helps balance thoroughness vs detectability
- **Evasion techniques** - Built-in firewall and IDS evasion options

### ⚡ Smart Automation
- **Pre-configured profiles** for common scenarios (stealth, vuln, discovery)
- **Intelligent parsing** - Type commands with or without arguments
- **Command templates** - Quick setups for different use cases
- **Auto-completion** - Guided selection for all options

### 🎓 Educational Focus
- **Learn while using** - Explanations for every technique
- **Best practices** - Built-in security assessment guidance  
- **Real-world examples** - Practical workflows and use cases
- **Detection education** - Understand the stealth implications

---

## 🚀 Quick Start

### Prerequisites
- Linux or macOS system
- Bash shell (4.0+)
- nmap installed and in PATH
- Root privileges recommended (for advanced scan types)

### Installation
```bash
# Download VADER
wget https://raw.githubusercontent.com/ahmadVader0/vader/main/vader.sh
# or
curl -O https://raw.githubusercontent.com/ahmadVader0/vader/main/vader.sh

# Make executable
chmod +x vader.sh

# Run VADER
./vader.sh
```

### First Scan in 30 Seconds
```bash
# Start VADER
./vader.sh

# Set target
VADER> target 192.168.1.1

# Quick scan
VADER> profile quick

# Execute
VADER> execute
```

---

## 📖 Usage Examples

### 🔍 Basic Network Discovery
```bash
VADER> target 192.168.1.0/24
VADER> profile discovery
VADER> execute
```

### 🕵️ Stealth Reconnaissance
```bash
VADER> target sensitive-server.com
VADER> profile stealth
VADER> stealth timing 1
VADER> stealth fragment
VADER> execute
```

### 🛡️ Vulnerability Assessment
```bash
VADER> target production-server.com
VADER> scan version
VADER> scripts vuln
VADER> output xml results.xml
VADER> execute
```

### 🌐 Web Application Testing
```bash
VADER> target webapp.company.com
VADER> ports 80,443,8080,8443
VADER> scripts web
VADER> scripts safe
VADER> execute
```

### 🎯 Custom Advanced Scan
```bash
VADER> target 10.0.0.0/24
VADER> scan syn
VADER> ports 1-65535
VADER> scripts default
VADER> stealth timing 2
VADER> stealth decoy 1.2.3.4,5.6.7.8,ME
VADER> output all comprehensive_scan
VADER> execute
```

---

## 🛠️ Installation

### System Requirements
- **OS**: Linux, macOS, or Windows (WSL)
- **Shell**: Bash 4.0 or higher
- **Dependencies**: nmap (latest version recommended)
- **Permissions**: Root access recommended for full functionality
- **Storage**: Minimal (< 1MB)

### Installation Methods

#### Method 1: Direct Download
```bash
wget https://raw.githubusercontent.com/ahmadVader0/vader/main/vader.sh
chmod +x vader.sh
./vader.sh --version
```

#### Method 2: Git Clone
```bash
git clone https://github.com/ahmadVader0/vader.git
cd vader
chmod +x vader.sh
./vader.sh
```

#### Method 3: Package Managers (Future)
```bash
# Coming soon
sudo apt install vader    # Ubuntu/Debian
brew install vader        # macOS
```

### Verification
```bash
# Check VADER version
./vader.sh --version


# Quick functionality test
echo -e "target 127.0.0.1\nscan ping\nbuild\nexit" | ./vader.sh
```

---

## 🎓 How It Works

### Architecture
VADER is built with a modular, function-based architecture in pure Bash:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  User Input     │───▶│  Command Parser  │───▶│  Function       │
│  (Interactive)  │    │  (Route & Validate) │  │  Handlers       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  nmap Command   │◀───│  Command Builder │◀───│  State Manager  │
│  Execution      │    │  (Assemble flags)│    │  (Track config) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Workflow
1. **Input Processing**: Parse user commands and arguments
2. **Validation**: Verify targets, ports, and options
3. **State Management**: Track current configuration and flags
4. **Detection Calculation**: Assess scan detectability in real-time
5. **Command Building**: Assemble final nmap command
6. **Execution**: Run nmap with built command and options

### Core Components
- **Interactive Parser**: Handles user input and command routing
- **Detection Engine**: Calculates and displays stealth levels
- **Profile System**: Pre-configured scan templates
- **Validation Layer**: Input verification and error handling
- **Help System**: Contextual guidance and examples

---

## 🔧 Command Reference

### Essential Commands
| Command | Description | Example |
|---------|-------------|---------|
| `target <ip>` | Set scan target | `target 192.168.1.1` |
| `scan <type>` | Choose scan type | `scan syn` |
| `ports <range>` | Set port range | `ports 80,443` |
| `scripts <type>` | Add NSE scripts | `scripts web` |
| `build` | Show final command | `build` |
| `execute` | Run the scan | `execute` |

### Scan Types
| Type | Description | Detection Level |
|------|-------------|----------------|
| `syn` | TCP SYN scan (default) | 2/5 |
| `connect` | TCP connect scan | 3/5 |
| `udp` | UDP scan | 2/5 |
| `ping` | Host discovery only | 1/5 |
| `version` | Service version detection | 2/5 |
| `os` | OS detection | 3/5 |
| `aggressive` | Comprehensive scan | 4/5 |

### Quick Profiles
| Profile | Configuration | Use Case |
|---------|---------------|----------|
| `quick` | SYN + Fast ports | Initial reconnaissance |
| `stealth` | T1 + Fragment + Delays | Maximum stealth |
| `full` | Version + OS + Scripts + All ports | Complete assessment |
| `vuln` | Version + Vuln scripts | Vulnerability scanning |
| `discovery` | Ping scan only | Network mapping |

### Stealth Options
| Technique | Command | Detection Impact |
|-----------|---------|-----------------|
| Timing | `stealth timing <0-5>` | Varies |
| Fragmentation | `stealth fragment` | -1 |
| Decoy | `stealth decoy <ips>` | -2 |
| Delays | `stealth delay <time>` | -2 |
| Source Port | `stealth source-port <port>` | -1 |

---

## 📊 Detection Level System

VADER's unique detection level system helps users understand the stealth implications of their scans:

```
[●○○○○] 0/5 - Ghost Mode (Undetectable)
[●●○○○] 1/5 - Very Low (Rarely noticed)  
[●●●○○] 2/5 - Low (Basic monitoring might catch)
[●●●●○] 3/5 - Medium (Will likely be logged)
[●●●●●] 4/5 - High (Definitely detected)
[●●●●●] 5/5 - Maximum (Alarms will trigger!)
```

### Detection Modifiers
- **Reducing Detection**: Slow timing, fragmentation, delays, decoys
- **Increasing Detection**: Fast timing, all ports, vulnerability scripts, aggressive scans

---

## 🎮 Interactive Features

### Smart Command Parsing
```bash
# Type commands with or without arguments
VADER> scan              # Shows scan type menu
VADER> scan syn          # Directly sets SYN scan

VADER> ports             # Shows port selection menu  
VADER> ports 80,443      # Directly sets specific ports
```

### Contextual Help
```bash
VADER> help              # Main help menu
VADER> explain sS        # Explains TCP SYN scan
VADER> examples stealth  # Shows stealth scan examples
VADER> detection         # Explains detection levels
```

### Real-time Feedback
- **Command Preview**: See your nmap command as you build it
- **Detection Updates**: Visual meter updates with each option
- **Validation Messages**: Immediate feedback on input errors
- **Status Display**: Current configuration always visible

---

## 📚 Documentation

### Available Documentation
- **📖 User Manual** (60+ pages): Comprehensive guide with examples
- **🎓 Quick Reference**: Essential commands and workflows  
- **💡 Best Practices**: Professional scanning methodologies
- **⚖️ Legal Guidelines**: Authorization and compliance requirements
- **🔧 Technical Reference**: All functions and parameters

### Getting Help
```bash
# In VADER
VADER> help              # Interactive help menu
VADER> explain <flag>    # Explain specific nmap flags
VADER> examples <type>   # Usage examples by category

# Command line
./vader.sh --help       # Command line help
./vader.sh --version    # Version information
```

### Learning Resources
- Step-by-step tutorials for common scenarios
- Real-world penetration testing workflows
- Security assessment methodologies  
- Compliance scanning procedures
- Advanced evasion techniques

---

## 🤝 Contributing

We welcome contributions from the cybersecurity community! Here's how you can help:

### Ways to Contribute
- 🐛 **Bug Reports**: Report issues and unexpected behavior
- 💡 **Feature Requests**: Suggest new functionality and improvements
- 📝 **Documentation**: Improve guides, examples, and explanations
- 💻 **Code**: Submit pull requests for bug fixes and features

### Development Setup
```bash
# Fork and clone the repository
git clone https://github.com/ahmadVader0/vader.git
cd vader

# Make changes 
nano vader.sh

# Commit and push
git commit -m "Add your feature description"
git push origin feature/your-feature-name

# Create pull request
```

### Coding Standards
- **Shell**: Follow bash best practices and style guidelines
- **Functions**: Keep functions focused and well-documented
- **Comments**: Explain complex logic and design decisions
- **Testing**: Add tests for new functionality
- **Documentation**: Update relevant documentation

### Community Guidelines
- Be respectful and professional
- Focus on educational and ethical use cases
- Follow responsible disclosure for security issues
- Help others learn and improve their security skills

---

## ⚖️ Legal & Ethics

### 🚨 Important Legal Notice
**VADER is designed for authorized security testing and educational purposes only.**

### Authorization Requirements
- ✅ **Always obtain explicit written permission** before scanning
- ✅ **Only scan systems you own** or have authorization to test
- ✅ **Respect scope limitations** and time windows
- ✅ **Follow responsible disclosure** for any vulnerabilities found

### Prohibited Uses
- ❌ Unauthorized network scanning or reconnaissance
- ❌ Malicious activities or attacks against systems
- ❌ Violation of computer crime laws or regulations
- ❌ Any activity that could cause harm or disruption

### Best Practices
1. **Documentation**: Maintain detailed records of all activities
2. **Coordination**: Work with system administrators and security teams
3. **Timing**: Schedule scans during appropriate maintenance windows
4. **Scope**: Stay within authorized boundaries and limitations
5. **Reporting**: Provide timely and accurate reports of findings

### Educational Use
VADER is designed to help security professionals learn and improve their skills in a safe, controlled environment. Use it responsibly to:
- Learn about network security assessment techniques
- Practice penetration testing methodologies
- Understand detection and evasion concepts
- Develop professional security skills

---

## 📄 License

### Educational License
This project is released under an Educational License for learning and authorized security testing purposes.

**Permitted Uses:**
- Educational and training activities
- Authorized penetration testing and security assessments
- Research and development in cybersecurity
- Personal learning and skill development

**Restrictions:**
- No commercial distribution without permission
- No use for malicious or unauthorized activities
- Must maintain copyright and license notices
- Must comply with applicable laws and regulations

**Disclaimer:**
This tool is provided "as is" without warranty. Users are responsible for ensuring compliance with all applicable laws and regulations. The authors assume no liability for misuse of this tool.

---

## 📞 Support & Contact

### Getting Help
- 📚 **Documentation**: Check the comprehensive user manual
- 🎓 **Built-in Help**: Use VADER's interactive help system
- 💬 **Community**: Engage with other users and contributors

### Reporting Issues
- 🐛 **Bug Reports**: Use GitHub Issues with detailed information
- 🚨 **Security Issues**: Follow responsible disclosure practices
- 💡 **Feature Requests**: Suggest improvements and new functionality

### Connect
- **LinkedIn**: https://www.linkedin.com/in/ahmad-kamal-483793365?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app
- **Email**: ak49392919@gmail.com

---

<p align="center">
  <em>VADER: Making advanced network security assessment accessible to everyone</em>
</p>

---

**⭐ Star this repository if VADER helps you with your security assessments!**

**🔄 Fork it to contribute and make it even better!**

**📢 Share it with fellow security professionals!**
