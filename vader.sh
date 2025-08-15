#!/bin/bash


# Colors 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variables
NMAP_COMMAND="nmap"
CURRENT_FLAGS=()
TARGET=""
DETECTION_LEVEL=0
OUTPUT_FILE=""

# UI FUNCTIONS
show_banner() {
    clear
    echo -e "${RED}"
    echo "██╗   ██╗ █████╗ ██████╗ ███████╗██████╗ "
    echo "██║   ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗"
    echo "██║   ██║███████║██║  ██║█████╗  ██████╔╝"
    echo "╚██╗ ██╔╝██╔══██║██║  ██║██╔══╝  ██╔══██╗"
    echo " ╚████╔╝ ██║  ██║██████╔╝███████╗██║  ██║"
    echo "  ╚═══╝  ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}    Advanced Nmap Command Builder Tool${NC}"
    echo -e "${YELLOW}           Version 1.3${NC}"
    echo -e "${GREEN}         By Ahmad Kamal${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}[!] For Educational and Authorized Testing Only${NC}"
    echo -e "${BLUE}[*] Interactive Command-Driven Nmap Interface${NC}"
    echo -e "${YELLOW}[*] Detection Level Awareness & Stealth Options${NC}"
    echo
    echo -e "${WHITE}Available Commands:${NC}"
    echo -e "${GREEN}  help     ${NC}- Show detailed help menu"
    echo -e "${GREEN}  menu     ${NC}- Clear screen and show this menu"
    echo -e "${GREEN}  target   ${NC}- Set scan target (IP/hostname/CIDR)"
    echo -e "${GREEN}  scan     ${NC}- Choose scan type with detection info"
    echo -e "${GREEN}  ports    ${NC}- Specify port range or selection"
    echo -e "${GREEN}  scripts  ${NC}- Add NSE scripts for enumeration"
    echo -e "${GREEN}  stealth  ${NC}- Configure stealth and evasion"
    echo -e "${GREEN}  output   ${NC}- Set output format and file"
    echo -e "${GREEN}  profile  ${NC}- Use quick scan profiles"
    echo -e "${GREEN}  build    ${NC}- Build and show final nmap command"
    echo -e "${GREEN}  execute  ${NC}- Run the built command"
    echo -e "${GREEN}  status   ${NC}- Show current configuration"
    echo -e "${GREEN}  save     ${NC}- Save command to file"
    echo -e "${GREEN}  reset    ${NC}- Clear current configuration"
    echo -e "${GREEN}  explain  ${NC}- Explain specific nmap flags"
    echo -e "${GREEN}  examples ${NC}- Show usage examples"
    echo -e "${GREEN}  detection${NC}- Show detection level information"
    echo -e "${GREEN}  exit     ${NC}- Exit VADER"
    echo
    echo -e "${RED}Reminder: Always ensure you have proper authorization before scanning!${NC}"
    echo
}

show_help() {
    echo -e "${CYAN}═══════════════ VADER HELP SYSTEM ═══════════════${NC}"
    echo
    echo -e "${YELLOW}BASIC WORKFLOW:${NC}"
    echo -e "${WHITE}1.${NC} Set target    → ${GREEN}target 192.168.1.1${NC}"
    echo -e "${WHITE}2.${NC} Choose scan    → ${GREEN}scan syn${NC}"
    echo -e "${WHITE}3.${NC} Select ports   → ${GREEN}ports 80,443${NC}"
    echo -e "${WHITE}4.${NC} Add scripts    → ${GREEN}scripts vuln${NC}"
    echo -e "${WHITE}5.${NC} Build command  → ${GREEN}build${NC}"
    echo -e "${WHITE}6.${NC} Execute scan   → ${GREEN}execute${NC}"
    echo
    echo -e "${YELLOW}TARGET COMMANDS:${NC}"
    echo -e "${GREEN}  target <ip>         ${NC}- Set single IP (192.168.1.1)"
    echo -e "${GREEN}  target <range>      ${NC}- Set IP range (192.168.1.1-50)"
    echo -e "${GREEN}  target <cidr>       ${NC}- Set subnet (192.168.1.0/24)"
    echo -e "${GREEN}  target <hostname>   ${NC}- Set hostname (google.com)"
    echo -e "${GREEN}  target file <file>  ${NC}- Load targets from file"
    echo -e "${GREEN}  exclude <hosts>     ${NC}- Exclude specific hosts"
    echo
    echo -e "${YELLOW}SCAN TYPES:${NC}"
    echo -e "${GREEN}  scan syn            ${NC}- TCP SYN scan (default, fast) [Detection: 2/5]"
    echo -e "${GREEN}  scan connect        ${NC}- TCP connect scan (reliable) [Detection: 3/5]"
    echo -e "${GREEN}  scan udp            ${NC}- UDP scan (slower) [Detection: 2/5]"
    echo -e "${GREEN}  scan ping           ${NC}- Ping scan only (discovery) [Detection: 1/5]"
    echo -e "${GREEN}  scan version        ${NC}- Service version detection [Detection: 2/5]"
    echo -e "${GREEN}  scan os             ${NC}- Operating system detection [Detection: 3/5]"
    echo -e "${GREEN}  scan aggressive     ${NC}- Full aggressive scan [Detection: 4/5]"
    echo
    echo -e "${YELLOW}PORT OPTIONS:${NC}"
    echo -e "${GREEN}  ports 80,443        ${NC}- Specific ports"
    echo -e "${GREEN}  ports 1-1000        ${NC}- Port range"
    echo -e "${GREEN}  ports top100        ${NC}- Top 100 ports"
    echo -e "${GREEN}  ports fast          ${NC}- Fast scan (100 common ports)"
    echo -e "${GREEN}  ports all           ${NC}- All 65535 ports [Detection: +2]"
    echo
    echo -e "${YELLOW}NSE SCRIPTS:${NC}"
    echo -e "${GREEN}  scripts default     ${NC}- Default safe scripts [Detection: +1]"
    echo -e "${GREEN}  scripts vuln        ${NC}- Vulnerability detection [Detection: +3]"
    echo -e "${GREEN}  scripts safe        ${NC}- Safe scripts only [Detection: +1]"
    echo -e "${GREEN}  scripts web         ${NC}- Web enumeration [Detection: +2]"
    echo -e "${GREEN}  scripts smb         ${NC}- SMB enumeration [Detection: +2]"
    echo -e "${GREEN}  scripts ssh         ${NC}- SSH enumeration [Detection: +1]"
    echo -e "${GREEN}  scripts ftp         ${NC}- FTP enumeration [Detection: +1]"
    echo -e "${GREEN}  scripts dns         ${NC}- DNS enumeration [Detection: +1]"
    echo -e "${GREEN}  scripts <name>      ${NC}- Custom script name [Detection: +2]"
    echo
    echo -e "${YELLOW}STEALTH & EVASION:${NC}"
    echo -e "${GREEN}  stealth timing <0-5>${NC}- Set timing (0=slowest, 5=fastest)"
    echo -e "${GREEN}                      ${NC}  T0=Paranoid, T1=Sneaky, T2=Polite"
    echo -e "${GREEN}                      ${NC}  T3=Normal, T4=Aggressive, T5=Insane"
    echo -e "${GREEN}  stealth fragment    ${NC}- Fragment packets [Detection: -1]"
    echo -e "${GREEN}  stealth decoy <ips> ${NC}- Use decoy IPs [Detection: -2]"
    echo -e "${GREEN}  stealth delay <time>${NC}- Add scan delay [Detection: -2]"
    echo -e "${GREEN}  stealth source-port <port>${NC}- Set source port [Detection: -1]"
    echo -e "${GREEN}  stealth spoof-mac <mac>${NC}- Spoof MAC address [Detection: -1]"
    echo -e "${GREEN}  stealth mtu <size>  ${NC}- Custom MTU size [Detection: -1]"
    echo -e "${GREEN}  stealth randomize   ${NC}- Randomize host order [Detection: -1]"
    echo
    echo -e "${YELLOW}HOST DISCOVERY:${NC}"
    echo -e "${GREEN}  no-ping             ${NC}- Skip host discovery [Detection: -1]"
    echo -e "${GREEN}  arp-ping            ${NC}- Use ARP ping (LAN only) [Detection: 0]"
    echo
    echo -e "${YELLOW}OUTPUT OPTIONS:${NC}"
    echo -e "${GREEN}  output normal <file>${NC}- Normal text output"
    echo -e "${GREEN}  output xml <file>   ${NC}- XML format output"
    echo -e "${GREEN}  output grepable <file>${NC}- Grepable format output"
    echo -e "${GREEN}  output all <base>   ${NC}- All formats (.nmap, .xml, .gnmap)"
    echo -e "${GREEN}  verbose on          ${NC}- Enable verbose mode"
    echo -e "${GREEN}  verbose 2           ${NC}- Extra verbose mode"
    echo
    echo -e "${YELLOW}UTILITY OPTIONS:${NC}"
    echo -e "${GREEN}  show-open           ${NC}- Show only open ports"
    echo -e "${GREEN}  add-reason          ${NC}- Show reason for port states"
    echo -e "${GREEN}  packet-trace        ${NC}- Show all packets (debugging)"
    echo
    echo -e "${YELLOW}QUICK PROFILES:${NC}"
    echo -e "${GREEN}  profile quick       ${NC}- Fast basic scan (SYN + Fast ports)"
    echo -e "${GREEN}  profile stealth     ${NC}- Maximum stealth (T1 + Fragment + Delay)"
    echo -e "${GREEN}  profile full        ${NC}- Comprehensive scan (SYN + Version + OS + Scripts + All ports)"
    echo -e "${GREEN}  profile vuln        ${NC}- Vulnerability assessment (SYN + Version + Vuln scripts)"
    echo -e "${GREEN}  profile discovery   ${NC}- Network discovery (Ping scan only)"
    echo
    echo -e "${YELLOW}COMMAND MANAGEMENT:${NC}"
    echo -e "${GREEN}  build               ${NC}- Show final nmap command"
    echo -e "${GREEN}  execute             ${NC}- Run the built command"
    echo -e "${GREEN}  save <filename>     ${NC}- Save command to file"
    echo -e "${GREEN}  reset               ${NC}- Clear all settings"
    echo -e "${GREEN}  status              ${NC}- Show current configuration"
    echo -e "${GREEN}  report <input> [output]${NC}- Generate simple report from results"
    echo
    echo -e "${YELLOW}HELP & INFORMATION:${NC}"
    echo -e "${GREEN}  help                ${NC}- Show this help"
    echo -e "${GREEN}  explain <flag>      ${NC}- Explain specific nmap flag (sS, sV, O, etc.)"
    echo -e "${GREEN}  examples <type>     ${NC}- Show usage examples (basic, stealth, vuln, web, discovery)"
    echo -e "${GREEN}  detection           ${NC}- Explain detection levels and stealth tips"
    echo
    echo -e "${YELLOW}VALIDATION & UTILITIES:${NC}"
    echo -e "${GREEN}  validate-port <port>${NC}- Check if port number is valid"
    echo -e "${GREEN}  validate-timing <level>${NC}- Check if timing value is valid"
    echo
    echo -e "${YELLOW}EXAMPLES - COMMON WORKFLOWS:${NC}"
    echo
    echo -e "${CYAN}  Quick Basic Scan:${NC}"
    echo -e "    ${WHITE}target 192.168.1.1${NC}"
    echo -e "    ${WHITE}profile quick${NC}"
    echo -e "    ${WHITE}execute${NC}"
    echo
    echo -e "${CYAN}  Stealth Network Discovery:${NC}"
    echo -e "    ${WHITE}target 10.0.0.0/24${NC}"
    echo -e "    ${WHITE}profile stealth${NC}"
    echo -e "    ${WHITE}no-ping${NC}"
    echo -e "    ${WHITE}execute${NC}"
    echo
    echo -e "${CYAN}  Web Application Assessment:${NC}"
    echo -e "    ${WHITE}target web-server.com${NC}"
    echo -e "    ${WHITE}scan version${NC}"
    echo -e "    ${WHITE}ports 80,443,8080,8443${NC}"
    echo -e "    ${WHITE}scripts web${NC}"
    echo -e "    ${WHITE}output xml web_results.xml${NC}"
    echo -e "    ${WHITE}execute${NC}"
    echo
    echo -e "${CYAN}  Comprehensive Vulnerability Scan:${NC}"
    echo -e "    ${WHITE}target 192.168.1.100${NC}"
    echo -e "    ${WHITE}scan version${NC}"
    echo -e "    ${WHITE}scripts vuln${NC}"
    echo -e "    ${WHITE}scripts safe${NC}"
    echo -e "    ${WHITE}output all vuln_scan${NC}"
    echo -e "    ${WHITE}verbose 2${NC}"
    echo -e "    ${WHITE}execute${NC}"
    echo
    echo -e "${CYAN}  Maximum Stealth Scan:${NC}"
    echo -e "    ${WHITE}target sensitive-host.com${NC}"
    echo -e "    ${WHITE}scan syn${NC}"
    echo -e "    ${WHITE}stealth timing 1${NC}"
    echo -e "    ${WHITE}stealth fragment${NC}"
    echo -e "    ${WHITE}stealth delay 15s${NC}"
    echo -e "    ${WHITE}stealth decoy 1.2.3.4,5.6.7.8,ME${NC}"
    echo -e "    ${WHITE}no-ping${NC}"
    echo -e "    ${WHITE}stealth randomize${NC}"
    echo -e "    ${WHITE}execute${NC}"
    echo
    echo -e "${YELLOW}DETECTION LEVELS:${NC}"
    echo -e "${GREEN}  [●○○○○] 0/5 Ghost     ${NC}- Undetectable"
    echo -e "${GREEN}  [●●○○○] 1/5 Very Low  ${NC}- Rarely noticed"
    echo -e "${YELLOW} [●●●○○] 2/5 Low       ${NC}- Basic monitoring might catch"
    echo -e "${YELLOW} [●●●●○] 3/5 Medium    ${NC}- Will be logged"
    echo -e "${RED}   [●●●●●] 4/5 High      ${NC}- Definitely detected"
    echo -e "${RED}   [●●●●●] 5/5 Maximum   ${NC}- Alarms will trigger!"
    echo
    echo -e "${YELLOW}TIPS:${NC}"
    echo -e "${BLUE}  • Start with 'target' to set your scan target${NC}"
    echo -e "${BLUE}  • Use 'profile' commands for quick setups${NC}"
    echo -e "${BLUE}  • Check detection levels before executing${NC}"
    echo -e "${BLUE}  • Use 'build' to review command before 'execute'${NC}"
    echo -e "${BLUE}  • Type 'status' anytime to see current config${NC}"
    echo -e "${BLUE}  • Save interesting commands with 'save'${NC}"
    echo
    echo -e "${RED}IMPORTANT REMINDERS:${NC}"
    echo -e "${RED}  • Only scan systems you own or have authorization to test${NC}"
    echo -e "${RED}  • High detection scans may trigger security responses${NC}"
    echo -e "${RED}  • Always have proper documentation and approval${NC}"
    echo -e "${RED}  • Use stealth options in sensitive environments${NC}"
    echo
    echo -e "${CYAN}Command line usage:${NC}"
    echo -e "${WHITE}  ./vader.sh --target <ip> --quick    ${NC}- Quick scan"
    echo -e "${WHITE}  ./vader.sh --help                   ${NC}- Show help"
    echo -e "${WHITE}  ./vader.sh --version                ${NC}- Show version"
    echo
}

show_detection_meter() {
    local level=$1
    
    echo -e "${YELLOW}Detection Level: ${NC}"
    
    if [ "$level" -eq 0 ]; then
        echo -e "${GREEN}[●○○○○] 0/5 - Ghost Mode (Undetectable)${NC}"
    elif [ "$level" -eq 1 ]; then
        echo -e "${GREEN}[●●○○○] 1/5 - Very Low (Rarely detected)${NC}"
    elif [ "$level" -eq 2 ]; then
        echo -e "${YELLOW}[●●●○○] 2/5 - Low (Basic detection)${NC}"
    elif [ "$level" -eq 3 ]; then
        echo -e "${YELLOW}[●●●●○] 3/5 - Medium (Likely detected)${NC}"
    elif [ "$level" -eq 4 ]; then
        echo -e "${RED}[●●●●●] 4/5 - High (Will be detected)${NC}"
    elif [ "$level" -eq 5 ]; then
        echo -e "${RED}[●●●●●] 5/5 - Maximum (Alarms will trigger!)${NC}"
    else
        echo -e "${WHITE}[○○○○○] Unknown Level${NC}"
    fi
    
    echo
}

display_current_command() {
    echo -e "${CYAN}═══════════ CURRENT COMMAND ═══════════${NC}"
    echo
    
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] No target set${NC}"
    else
        echo -e "${GREEN}Target: ${WHITE}$TARGET${NC}"
    fi
    
    if [ ${#CURRENT_FLAGS[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No scan options set${NC}"
    else
        echo -e "${GREEN}Options: ${WHITE}${CURRENT_FLAGS[*]}${NC}"
    fi
    
    echo
    echo -e "${BLUE}Command:${NC}"
    if [ -z "$TARGET" ]; then
        echo -e "${WHITE}nmap ${CURRENT_FLAGS[*]} <target_needed>${NC}"
    else
        echo -e "${WHITE}nmap ${CURRENT_FLAGS[*]} $TARGET${NC}"
    fi
    
    echo
    if [ "$DETECTION_LEVEL" -gt 0 ]; then
        show_detection_meter "$DETECTION_LEVEL"
    fi
    
    if [ -n "$OUTPUT_FILE" ]; then
        echo -e "${GREEN}Output will be saved to: ${WHITE}$OUTPUT_FILE${NC}"
        echo
    fi
}

# COMMAND PARSING 
show_main_menu() {
    clear
    show_banner
}

parse_command() {
    local input="$1"
    local cmd=$(echo "$input" | awk '{print $1}')
    local arg=$(echo "$input" | awk '{print $2}')
    local arg2=$(echo "$input" | awk '{print $3}')
    
    case "$cmd" in
        "help"|"h")
            show_help
            ;;
        "menu"|"m")
            show_main_menu
            ;;
        "target"|"t")
            if [ -z "$arg" ]; then
                handle_target_input
            else
                TARGET="$arg"
                echo -e "${GREEN}Target set to: $TARGET${NC}"
            fi
            ;;
        "scan"|"s")
            if [ -z "$arg" ]; then
                handle_scan_selection
            else
                case "$arg" in
                    "syn") add_tcp_syn_scan ;;
                    "connect") add_tcp_connect_scan ;;
                    "udp") add_udp_scan ;;
                    "ping") add_ping_scan ;;
                    "version") add_version_scan ;;
                    "os") add_os_scan ;;
                    "aggressive") add_aggressive_scan ;;
                    *) 
                        echo -e "${RED}Unknown scan type: $arg${NC}"
                        handle_scan_selection
                        ;;
                esac
            fi
            ;;
        "ports"|"p")
            if [ -z "$arg" ]; then
                handle_port_selection
            else
                case "$arg" in
                    "fast") add_fast_scan ;;
                    "all") add_all_ports ;;
                    "top100") add_top_ports "100" ;;
                    *) add_port_range "$arg" ;;
                esac
            fi
            ;;
        "scripts"|"script")
            if [ -z "$arg" ]; then
                handle_script_selection
            else
                case "$arg" in
                    "default") add_default_scripts ;;
                    "vuln") add_vuln_scripts ;;
                    "safe") add_safe_scripts ;;
                    "web") add_web_enum ;;
                    "smb") add_smb_enum ;;
                    "ssh") add_ssh_enum ;;
                    "ftp") add_ftp_enum ;;
                    "dns") add_dns_enum ;;
                    *) add_custom_script "$arg" ;;
                esac
            fi
            ;;
        "stealth")
            if [ -z "$arg" ]; then
                handle_stealth_selection
            else
                case "$arg" in
                    "timing") 
                        if [ -z "$arg2" ]; then
                            handle_timing_selection
                        else
                            add_timing_template "$arg2"
                        fi
                        ;;
                    "fragment") add_fragment_packets ;;
                    "decoy") 
                        if [ -z "$arg2" ]; then
                            handle_decoy_input
                        else
                            add_decoy_scan "$arg2"
                        fi
                        ;;
                    "delay") 
                        if [ -z "$arg2" ]; then
                            handle_delay_input
                        else
                            add_scan_delay "$arg2"
                        fi
                        ;;
                    "source-port")
                        if [ -z "$arg2" ]; then
                            handle_source_port_input
                        else
                            add_source_port "$arg2"
                        fi
                        ;;
                    "spoof-mac")
                        if [ -z "$arg2" ]; then
                            handle_mac_spoof_input
                        else
                            add_spoof_mac "$arg2"
                        fi
                        ;;
                    "mtu")
                        if [ -z "$arg2" ]; then
                            handle_mtu_input
                        else
                            add_mtu_size "$arg2"
                        fi
                        ;;
                    "randomize") add_randomize_hosts ;;
                    *) handle_stealth_selection ;;
                esac
            fi
            ;;
        "output"|"o")
            if [ -z "$arg" ]; then
                handle_output_selection
            else
                case "$arg" in
                    "normal") 
                        if [ -z "$arg2" ]; then
                            handle_output_filename "normal"
                        else
                            add_output_normal "$arg2"
                        fi
                        ;;
                    "xml") 
                        if [ -z "$arg2" ]; then
                            handle_output_filename "xml"
                        else
                            add_output_xml "$arg2"
                        fi
                        ;;
                    "grepable") 
                        if [ -z "$arg2" ]; then
                            handle_output_filename "grepable"
                        else
                            add_output_grepable "$arg2"
                        fi
                        ;;
                    "all") 
                        if [ -z "$arg2" ]; then
                            handle_output_filename "all"
                        else
                            add_output_all "$arg2"
                        fi
                        ;;
                    *) handle_output_selection ;;
                esac
            fi
            ;;
        "profile")
            if [ -z "$arg" ]; then
                handle_profile_selection
            else
                case "$arg" in
                    "quick") quick_scan_profile ;;
                    "stealth") stealth_scan_profile ;;
                    "full") comprehensive_scan_profile ;;
                    "vuln") vulnerability_scan_profile ;;
                    "discovery") discovery_scan_profile ;;
                    *) handle_profile_selection ;;
                esac
            fi
            ;;
        "verbose"|"v")
            if [ -z "$arg" ]; then
                handle_verbose_selection
            else
                add_verbose "$arg"
            fi
            ;;
        "no-ping")
            add_no_ping
            ;;
        "arp-ping")
            add_arp_ping
            ;;
        "show-open")
            show_open_ports
            ;;
        "add-reason")
            add_reason
            ;;
        "packet-trace")
            add_packet_trace
            ;;
        "exclude")
            if [ -z "$arg" ]; then
                handle_exclude_input
            else
                add_exclude_hosts "$arg"
            fi
            ;;
        "build"|"b")
            build_command
            ;;
        "execute"|"run"|"e")
            execute_command
            ;;
        "save")
            if [ -z "$arg" ]; then
                handle_save_input
            else
                save_command "$arg"
            fi
            ;;
        "report")
            if [ -z "$arg" ]; then
                handle_report_input
            else
                generate_simple_report "$arg" "$arg2"
            fi
            ;;
        "reset"|"clear")
            reset_command
            ;;
        "status"|"show")
            display_current_command
            ;;
        "explain")
            if [ -z "$arg" ]; then
                handle_explain_input
            else
                explain_flag "$arg"
            fi
            ;;
        "examples")
            if [ -z "$arg" ]; then
                handle_examples_input
            else
                show_examples "$arg"
            fi
            ;;
        "detection")
            show_detection_info
            ;;
        "validate-port")
            if [ -z "$arg" ]; then
                handle_port_validation_input
            else
                validate_port "$arg"
            fi
            ;;
        "validate-timing")
            if [ -z "$arg" ]; then
                handle_timing_validation_input
            else
                validate_timing "$arg"
            fi
            ;;
        "exit"|"quit"|"q")
            echo -e "${YELLOW}Goodbye!${NC}"
            exit 0
            ;;
        "")
            # Empty input, do nothing
            ;;
        *)
            echo -e "${RED}Unknown command: $cmd${NC}"
            echo -e "${YELLOW}Type 'help' for available commands${NC}"
            ;;
    esac
}

# INTERACTIVE HANDLERS 

handle_port_selection() {
    echo -e "${YELLOW}═══════════ PORT SELECTION ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose port selection method:${NC}"
    echo
    echo -e "${GREEN}1.${NC} Fast Scan        - Top 100 most common ports"
    echo -e "${GREEN}2.${NC} Top Ports        - Specify number of top ports"
    echo -e "${GREEN}3.${NC} Specific Ports   - Enter comma-separated ports"
    echo -e "${GREEN}4.${NC} Port Range       - Enter range (e.g., 1-1000)"
    echo -e "${GREEN}5.${NC} All Ports        - Scan all 65535 ports (slow!)"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-5 or 'back'): ${NC}"
        read -r choice
        
        case "$choice" in
            1)
                add_fast_scan
                break
                ;;
            2)
                echo -ne "${WHITE}Enter number of top ports (default 1000): ${NC}"
                read -r num_ports
                if [ -z "$num_ports" ]; then
                    num_ports="1000"
                fi
                add_top_ports "$num_ports"
                break
                ;;
            3)
                echo -ne "${WHITE}Enter ports (e.g., 80,443,22): ${NC}"
                read -r ports
                if [ -n "$ports" ]; then
                    add_port_range "$ports"
                    break
                else
                    echo -e "${RED}Please enter at least one port${NC}"
                fi
                ;;
            4)
                echo -ne "${WHITE}Enter port range (e.g., 1-1000): ${NC}"
                read -r range
                if [ -n "$range" ]; then
                    add_port_range "$range"
                    break
                else
                    echo -e "${RED}Please enter a valid range${NC}"
                fi
                ;;
            5)
                echo -e "${RED}Warning: This will scan all 65535 ports and take a very long time!${NC}"
                echo -ne "${WHITE}Continue? (y/N): ${NC}"
                read -r confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    add_all_ports
                    break
                fi
                ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-5${NC}"
                ;;
        esac
    done
}

handle_script_selection() {
    echo -e "${YELLOW}═══════════ SCRIPT SELECTION ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose NSE scripts to run:${NC}"
    echo
    echo -e "${GREEN}1.${NC} Default Scripts  - Safe, commonly used scripts [+1 detection]"
    echo -e "${GREEN}2.${NC} Safe Scripts     - Non-intrusive scripts only [+1 detection]"
    echo -e "${GREEN}3.${NC} Vulnerability    - Find known vulnerabilities [+3 detection]"
    echo -e "${GREEN}4.${NC} Web Enumeration  - HTTP/HTTPS services [+2 detection]"
    echo -e "${GREEN}5.${NC} SMB Enumeration  - Windows SMB services [+2 detection]"
    echo -e "${GREEN}6.${NC} SSH Enumeration  - SSH service info [+1 detection]"
    echo -e "${GREEN}7.${NC} FTP Enumeration  - FTP service info [+1 detection]"
    echo -e "${GREEN}8.${NC} DNS Enumeration  - DNS service info [+1 detection]"
    echo -e "${GREEN}9.${NC} Custom Script    - Enter specific script name [+2 detection]"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-9 or 'back'): ${NC}"
        read -r choice
        
        case "$choice" in
            1) add_default_scripts; break ;;
            2) add_safe_scripts; break ;;
            3) add_vuln_scripts; break ;;
            4) add_web_enum; break ;;
            5) add_smb_enum; break ;;
            6) add_ssh_enum; break ;;
            7) add_ftp_enum; break ;;
            8) add_dns_enum; break ;;
            9)
                echo -ne "${WHITE}Enter script name: ${NC}"
                read -r script_name
                if [ -n "$script_name" ]; then
                    add_custom_script "$script_name"
                    break
                else
                    echo -e "${RED}Please enter a script name${NC}"
                fi
                ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-9${NC}"
                ;;
        esac
    done
}

handle_stealth_selection() {
    echo -e "${YELLOW}═══════════ STEALTH OPTIONS ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose stealth technique:${NC}"
    echo
    echo -e "${GREEN}1.${NC} Timing Template  - Control scan speed (T0-T5)"
    echo -e "${GREEN}2.${NC} Fragment Packets - Split packets to evade filters [-1 detection]"
    echo -e "${GREEN}3.${NC} Decoy Scan       - Hide among fake IPs [-2 detection]"
    echo -e "${GREEN}4.${NC} Scan Delay       - Add delays between probes [-2 detection]"
    echo -e "${GREEN}5.${NC} Source Port      - Use specific source port [-1 detection]"
    echo -e "${GREEN}6.${NC} MAC Spoofing     - Hide real MAC address [-1 detection]"
    echo -e "${GREEN}7.${NC} MTU Size         - Custom packet size [-1 detection]"
    echo -e "${GREEN}8.${NC} Randomize Hosts  - Random target order [-1 detection]"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-8 or 'back'): ${NC}"
        read -r choice
        
        case "$choice" in
            1) handle_timing_selection; break ;;
            2) add_fragment_packets; break ;;
            3) handle_decoy_input; break ;;
            4) handle_delay_input; break ;;
            5) handle_source_port_input; break ;;
            6) handle_mac_spoof_input; break ;;
            7) handle_mtu_input; break ;;
            8) add_randomize_hosts; break ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-8${NC}"
                ;;
        esac
    done
}

handle_timing_selection() {
    echo -e "${YELLOW}═══════════ TIMING SELECTION ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose timing template:${NC}"
    echo
    echo -e "${GREEN}0.${NC} T0 Paranoid   - 5+ minutes between probes [Ghost mode]"
    echo -e "${GREEN}1.${NC} T1 Sneaky     - 15 seconds between probes [Very stealthy]"
    echo -e "${GREEN}2.${NC} T2 Polite     - Less bandwidth intensive [Stealthy]"
    echo -e "${GREEN}3.${NC} T3 Normal     - Default nmap timing [Normal]"
    echo -e "${GREEN}4.${NC} T4 Aggressive - Fast, assumes good network [Detectable]"
    echo -e "${GREEN}5.${NC} T5 Insane     - Very fast, may miss results [Very detectable]"
    echo
    
    while true; do
        echo -ne "${WHITE}Select timing (0-5 or 'back'): ${NC}"
        read -r timing
        
        case "$timing" in
            [0-5])
                add_timing_template "$timing"
                break
                ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 0-5${NC}"
                ;;
        esac
    done
}

handle_output_selection() {
    echo -e "${YELLOW}═══════════ OUTPUT FORMAT ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose output format:${NC}"
    echo
    echo -e "${GREEN}1.${NC} Normal Text   - Human-readable format"
    echo -e "${GREEN}2.${NC} XML Format    - Structured XML for tools"
    echo -e "${GREEN}3.${NC} Grepable      - Single-line format for filtering"
    echo -e "${GREEN}4.${NC} All Formats   - Creates all three formats"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-4 or 'back'): ${NC}"
        read -r choice
        
        case "$choice" in
            1) handle_output_filename "normal"; break ;;
            2) handle_output_filename "xml"; break ;;
            3) handle_output_filename "grepable"; break ;;
            4) handle_output_filename "all"; break ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-4${NC}"
                ;;
        esac
    done
}

handle_profile_selection() {
    echo -e "${YELLOW}═══════════ SCAN PROFILES ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose a pre-configured scan profile:${NC}"
    echo
    echo -e "${GREEN}1.${NC} Quick Profile        - Fast basic scan (SYN + Fast ports)"
    echo -e "${GREEN}2.${NC} Stealth Profile      - Maximum stealth (T1 + Fragment + Delays)"
    echo -e "${GREEN}3.${NC} Comprehensive        - Full assessment (Version + OS + Scripts + All ports)"
    echo -e "${GREEN}4.${NC} Vulnerability        - Security assessment (Version + Vuln scripts)"
    echo -e "${GREEN}5.${NC} Discovery Profile    - Network mapping (Ping scan only)"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-5 or 'back'): ${NC}"
        read -r choice
        
        case "$choice" in
            1) quick_scan_profile; break ;;
            2) stealth_scan_profile; break ;;
            3) comprehensive_scan_profile; break ;;
            4) vulnerability_scan_profile; break ;;
            5) discovery_scan_profile; break ;;
            "back"|"cancel"|"")
                return 1
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-5${NC}"
                ;;
        esac
    done
}

# SIMPLE INPUT HANDLERS 

handle_decoy_input() {
    echo -e "${BLUE}Enter decoy IP addresses (comma-separated):${NC}"
    echo -e "${YELLOW}Example: 192.168.1.5,192.168.1.10,ME${NC}"
    echo -e "${WHITE}Use 'ME' to include your real IP in random position${NC}"
    echo -ne "${WHITE}Decoys> ${NC}"
    read -r decoys
    if [ -n "$decoys" ]; then
        add_decoy_scan "$decoys"
    else
        echo -e "${RED}No decoys entered${NC}"
    fi
}

handle_delay_input() {
    echo -e "${BLUE}Enter scan delay time:${NC}"
    echo -e "${YELLOW}Examples: 5s (5 seconds), 10ms (10 milliseconds), 1m (1 minute)${NC}"
    echo -ne "${WHITE}Delay> ${NC}"
    read -r delay
    if [ -n "$delay" ]; then
        add_scan_delay "$delay"
    else
        echo -e "${RED}No delay entered${NC}"
    fi
}

handle_source_port_input() {
    echo -e "${BLUE}Enter source port number:${NC}"
    echo -e "${YELLOW}Common trusted ports: 53 (DNS), 80 (HTTP), 443 (HTTPS)${NC}"
    echo -ne "${WHITE}Port> ${NC}"
    read -r port
    if [ -n "$port" ] && validate_port "$port"; then
        add_source_port "$port"
    else
        echo -e "${RED}Invalid port number${NC}"
    fi
}

handle_mac_spoof_input() {
    echo -e "${BLUE}MAC address spoofing options:${NC}"
    echo -e "${YELLOW}1. Enter specific MAC (00:11:22:33:44:55)${NC}"
    echo -e "${YELLOW}2. Type 'random' for random MAC${NC}"
    echo -ne "${WHITE}MAC> ${NC}"
    read -r mac
    if [ -n "$mac" ]; then
        add_spoof_mac "$mac"
    else
        echo -e "${RED}No MAC address entered${NC}"
    fi
}

handle_mtu_input() {
    echo -e "${BLUE}Enter MTU size:${NC}"
    echo -e "${YELLOW}Common values: 1500 (Ethernet), 1492 (PPPoE), 576 (minimum)${NC}"
    echo -ne "${WHITE}MTU> ${NC}"
    read -r mtu
    if [ -n "$mtu" ]; then
        add_mtu_size "$mtu"
    else
        echo -e "${RED}No MTU size entered${NC}"
    fi
}

handle_output_filename() {
    local format="$1"
    echo -e "${BLUE}Enter filename for $format output:${NC}"
    case "$format" in
        "normal") echo -e "${YELLOW}Example: scan_results.txt${NC}" ;;
        "xml") echo -e "${YELLOW}Example: scan_results.xml${NC}" ;;
        "grepable") echo -e "${YELLOW}Example: scan_results.gnmap${NC}" ;;
        "all") echo -e "${YELLOW}Example: scan_results (will create .nmap, .xml, .gnmap)${NC}" ;;
    esac
    echo -ne "${WHITE}Filename> ${NC}"
    read -r filename
    if [ -n "$filename" ]; then
        case "$format" in
            "normal") add_output_normal "$filename" ;;
            "xml") add_output_xml "$filename" ;;
            "grepable") add_output_grepable "$filename" ;;
            "all") add_output_all "$filename" ;;
        esac
    else
        echo -e "${RED}No filename entered${NC}"
    fi
}

handle_verbose_selection() {
    echo -e "${BLUE}Choose verbosity level:${NC}"
    echo -e "${GREEN}1.${NC} Normal verbose (-v)"
    echo -e "${GREEN}2.${NC} Extra verbose (-vv)"
    echo -ne "${WHITE}Select (1-2): ${NC}"
    read -r level
    case "$level" in
        1) add_verbose "1" ;;
        2) add_verbose "2" ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

handle_exclude_input() {
    echo -e "${BLUE}Enter hosts to exclude (comma-separated):${NC}"
    echo -e "${YELLOW}Example: 192.168.1.1,192.168.1.5${NC}"
    echo -ne "${WHITE}Exclude> ${NC}"
    read -r hosts
    if [ -n "$hosts" ]; then
        add_exclude_hosts "$hosts"
    else
        echo -e "${RED}No hosts entered${NC}"
    fi
}

handle_save_input() {
    echo -e "${BLUE}Enter filename to save command:${NC}"
    echo -e "${YELLOW}Example: my_scan_command.txt${NC}"
    echo -ne "${WHITE}Filename> ${NC}"
    read -r filename
    if [ -n "$filename" ]; then
        save_command "$filename"
    else
        echo -e "${RED}No filename entered${NC}"
    fi
}

handle_report_input() {
    echo -e "${BLUE}Enter input file (scan results):${NC}"
    echo -e "${YELLOW}Example: scan_results.xml${NC}"
    echo -ne "${WHITE}Input file> ${NC}"
    read -r input_file
    if [ -n "$input_file" ]; then
        echo -e "${BLUE}Enter output file (optional):${NC}"
        echo -ne "${WHITE}Output file> ${NC}"
        read -r output_file
        generate_simple_report "$input_file" "$output_file"
    else
        echo -e "${RED}No input file entered${NC}"
    fi
}

handle_explain_input() {
    echo -e "${BLUE}Enter flag to explain:${NC}"
    echo -e "${YELLOW}Examples: sS, sV, O, A, sC, T1, f${NC}"
    echo -ne "${WHITE}Flag> ${NC}"
    read -r flag
    if [ -n "$flag" ]; then
        explain_flag "$flag"
    else
        echo -e "${RED}No flag entered${NC}"
    fi
}

handle_examples_input() {
    echo -e "${BLUE}Choose example type:${NC}"
    echo -e "${GREEN}1.${NC} Basic scans"
    echo -e "${GREEN}2.${NC} Stealth techniques"
    echo -e "${GREEN}3.${NC} Vulnerability assessment"
    echo -e "${GREEN}4.${NC} Web application scanning"
    echo -e "${GREEN}5.${NC} Network discovery"
    echo -ne "${WHITE}Select (1-5): ${NC}"
    read -r choice
    case "$choice" in
        1) show_examples "basic" ;;
        2) show_examples "stealth" ;;
        3) show_examples "vuln" ;;
        4) show_examples "web" ;;
        5) show_examples "discovery" ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

handle_port_validation_input() {
    echo -e "${BLUE}Enter port number to validate:${NC}"
    echo -ne "${WHITE}Port> ${NC}"
    read -r port
    if [ -n "$port" ]; then
        validate_port "$port"
    else
        echo -e "${RED}No port entered${NC}"
    fi
}

handle_timing_validation_input() {
    echo -e "${BLUE}Enter timing value to validate (0-5):${NC}"
    echo -ne "${WHITE}Timing> ${NC}"
    read -r timing
    if [ -n "$timing" ]; then
        validate_timing "$timing"
    else
        echo -e "${RED}No timing value entered${NC}"
    fi
}

validate_target() {
    local target="$1"
    
    # Check if target is empty
    if [ -z "$target" ]; then
        echo -e "${RED}Error: Target cannot be empty${NC}"
        return 1
    fi
    
    # Check for CIDR notation (has /)
    if [[ "$target" == *"/"* ]]; then
        echo -e "${GREEN}CIDR notation detected: $target${NC}"
        return 0
    fi
    
    # Check for IP range (has -)
    if [[ "$target" == *"-"* ]]; then
        echo -e "${GREEN}IP range detected: $target${NC}"
        return 0
    fi
    
    # Check if it looks like an IP address (has dots)
    if [[ "$target" == *.*.*.* ]]; then
        echo -e "${GREEN}IP address detected: $target${NC}"
        return 0
    fi
    
    # Check if it contains only valid hostname characters
    if [[ "$target" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo -e "${GREEN}Hostname detected: $target${NC}"
        return 0
    fi
    
    # If we get here, target format is invalid
    echo -e "${RED}Invalid target format: $target${NC}"
    echo -e "${YELLOW}Valid formats:${NC}"
    echo -e "  IP: 192.168.1.1"
    echo -e "  Range: 192.168.1.1-50"
    echo -e "  CIDR: 192.168.1.0/24"
    echo -e "  Hostname: google.com"
    return 1
}

# ESSENTIAL SCAN TYPES 
add_tcp_syn_scan() {
    CURRENT_FLAGS+=("-sS")
    DETECTION_LEVEL=2
    
    echo -e "${GREEN}[+] TCP SYN scan added${NC}"
    echo -e "${BLUE}Info: Fast half-open scan (default nmap scan)${NC}"
    echo -e "${YELLOW}Uses: Port discovery, service detection${NC}"
    
    show_detection_meter 2
}

add_tcp_connect_scan() {
    CURRENT_FLAGS+=("-sT")
    DETECTION_LEVEL=3
    
    echo -e "${GREEN}[+] TCP Connect scan added${NC}"
    echo -e "${BLUE}Info: Full TCP connection scan (more reliable)${NC}"
    echo -e "${YELLOW}Uses: When SYN scan fails, non-root users${NC}"
    
    show_detection_meter 3
}

add_udp_scan() {
    CURRENT_FLAGS+=("-sU")
    DETECTION_LEVEL=2
    
    echo -e "${GREEN}[+] UDP scan added${NC}"
    echo -e "${BLUE}Info: Scans UDP ports (slower than TCP)${NC}"
    echo -e "${YELLOW}Uses: DNS, DHCP, SNMP, and other UDP services${NC}"
    
    show_detection_meter 2
}

add_stealth_syn_scan() {
    CURRENT_FLAGS+=("-sS" "-T1" "-f")
    DETECTION_LEVEL=1
    
    echo -e "${GREEN}[+] Stealth SYN scan added${NC}"
    echo -e "${BLUE}Info: SYN scan with slow timing and fragmentation${NC}"
    echo -e "${YELLOW}Uses: Maximum stealth, avoiding detection${NC}"
    
    show_detection_meter 1
}

add_ping_scan() {
    CURRENT_FLAGS+=("-sn")
    DETECTION_LEVEL=1
    
    echo -e "${GREEN}[+] Ping scan added${NC}"
    echo -e "${BLUE}Info: Host discovery only (no port scanning)${NC}"
    echo -e "${YELLOW}Uses: Network discovery, finding live hosts${NC}"
    
    show_detection_meter 1
}

add_version_scan() {
    CURRENT_FLAGS+=("-sV")
    DETECTION_LEVEL=2
    
    echo -e "${GREEN}[+] Service version scan added${NC}"
    echo -e "${BLUE}Info: Detects service versions on open ports${NC}"
    echo -e "${YELLOW}Uses: Identifying software versions, finding vulnerabilities${NC}"
    
    show_detection_meter 2
}

add_os_scan() {
    CURRENT_FLAGS+=("-O")
    DETECTION_LEVEL=3
    
    echo -e "${GREEN}[+] OS detection scan added${NC}"
    echo -e "${BLUE}Info: Attempts to identify target operating system${NC}"
    echo -e "${YELLOW}Uses: System fingerprinting, attack planning${NC}"
    
    show_detection_meter 3
}

add_aggressive_scan() {
    CURRENT_FLAGS+=("-A")
    DETECTION_LEVEL=4
    
    echo -e "${GREEN}[+] Aggressive scan added${NC}"
    echo -e "${BLUE}Info: Combines -sV -O -sC --traceroute (full detection)${NC}"
    echo -e "${YELLOW}Uses: Complete system profiling, maximum information${NC}"
    
    show_detection_meter 4
}

# === PORT SPECIFICATION ===
add_port_range() {
    local ports="$1"
    
    if [ -z "$ports" ]; then
        echo -e "${RED}Usage: ports <range> (e.g., 80,443 or 1-1000)${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-p" "$ports")
    
    echo -e "${GREEN}[+] Port range added: $ports${NC}"
    echo -e "${BLUE}Info: Scanning specific ports only${NC}"
    echo -e "${YELLOW}Uses: Targeting known services, faster scans${NC}"
}

add_top_ports() {
    local num_ports="$1"
    
    if [ -z "$num_ports" ]; then
        num_ports="100"
    fi
    
    CURRENT_FLAGS+=("--top-ports" "$num_ports")
    
    echo -e "${GREEN}[+] Top $num_ports ports scan added${NC}"
    echo -e "${BLUE}Info: Scans most common ports based on frequency${NC}"
    echo -e "${YELLOW}Uses: Quick discovery of common services${NC}"
}

add_fast_scan() {
    CURRENT_FLAGS+=("-F")
    
    echo -e "${GREEN}[+] Fast scan added${NC}"
    echo -e "${BLUE}Info: Scans top 100 most common ports${NC}"
    echo -e "${YELLOW}Uses: Quick port discovery, initial reconnaissance${NC}"
}

add_all_ports() {
    CURRENT_FLAGS+=("-p-")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 2))
    
    echo -e "${GREEN}[+] All ports scan added${NC}"
    echo -e "${BLUE}Info: Scans all 65535 TCP ports (very slow)${NC}"
    echo -e "${YELLOW}Uses: Comprehensive port discovery${NC}"
    echo -e "${RED}Warning: This will take a long time and be very noticeable!${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# TIMING TEMPLATES
add_timing_template() {
    local timing="$1"
    
    if [ -z "$timing" ]; then
        echo -e "${RED}Usage: stealth timing <0-5>${NC}"
        echo -e "${YELLOW}0=Paranoid, 1=Sneaky, 2=Polite, 3=Normal, 4=Aggressive, 5=Insane${NC}"
        return 1
    fi
    
    case "$timing" in
        0)
            CURRENT_FLAGS+=("-T0")
            DETECTION_LEVEL=0
            echo -e "${GREEN}[+] T0 Paranoid timing added${NC}"
            echo -e "${BLUE}Info: Extremely slow (5+ min between probes)${NC}"
            ;;
        1)
            CURRENT_FLAGS+=("-T1")
            DETECTION_LEVEL=0
            echo -e "${GREEN}[+] T1 Sneaky timing added${NC}"
            echo -e "${BLUE}Info: Very slow (15 sec between probes)${NC}"
            ;;
        2)
            CURRENT_FLAGS+=("-T2")
            DETECTION_LEVEL=1
            echo -e "${GREEN}[+] T2 Polite timing added${NC}"
            echo -e "${BLUE}Info: Slow and less bandwidth intensive${NC}"
            ;;
        3)
            CURRENT_FLAGS+=("-T3")
            DETECTION_LEVEL=2
            echo -e "${GREEN}[+] T3 Normal timing added${NC}"
            echo -e "${BLUE}Info: Default nmap timing (recommended)${NC}"
            ;;
        4)
            CURRENT_FLAGS+=("-T4")
            DETECTION_LEVEL=3
            echo -e "${GREEN}[+] T4 Aggressive timing added${NC}"
            echo -e "${BLUE}Info: Fast scan assuming reliable network${NC}"
            ;;
        5)
            CURRENT_FLAGS+=("-T5")
            DETECTION_LEVEL=4
            echo -e "${GREEN}[+] T5 Insane timing added${NC}"
            echo -e "${BLUE}Info: Very fast, may miss results${NC}"
            ;;
        *)
            echo -e "${RED}Invalid timing level: $timing${NC}"
            echo -e "${YELLOW}Use 0-5 (0=slowest/stealthiest, 5=fastest/noisiest)${NC}"
            return 1
            ;;
    esac
    
    show_detection_meter $DETECTION_LEVEL
}

# ESSENTIAL NSE SCRIPTS 
add_default_scripts() {
    CURRENT_FLAGS+=("-sC")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 1))
    
    echo -e "${GREEN}[+] Default NSE scripts added${NC}"
    echo -e "${BLUE}Info: Runs safe and commonly used scripts${NC}"
    echo -e "${YELLOW}Uses: Basic service enumeration and info gathering${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_vuln_scripts() {
    CURRENT_FLAGS+=("--script" "vuln")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 3))
    
    echo -e "${GREEN}[+] Vulnerability scripts added${NC}"
    echo -e "${BLUE}Info: Scans for known vulnerabilities${NC}"
    echo -e "${YELLOW}Uses: Finding CVEs, security weaknesses${NC}"
    echo -e "${RED}Warning: These scripts actively probe for vulnerabilities!${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_safe_scripts() {
    CURRENT_FLAGS+=("--script" "safe")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 1))
    
    echo -e "${GREEN}[+] Safe scripts added${NC}"
    echo -e "${BLUE}Info: Non-intrusive information gathering scripts${NC}"
    echo -e "${YELLOW}Uses: Service detection without triggering alerts${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_custom_script() {
    local script_name="$1"
    
    if [ -z "$script_name" ]; then
        echo -e "${RED}Usage: scripts <script_name>${NC}"
        echo -e "${YELLOW}Example: scripts http-title${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--script" "$script_name")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 2))
    
    echo -e "${GREEN}[+] Custom script added: $script_name${NC}"
    echo -e "${BLUE}Info: Running specific NSE script${NC}"
    echo -e "${YELLOW}Uses: Targeted enumeration or testing${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# HOST DISCOVERY 
add_no_ping() {
    CURRENT_FLAGS+=("-Pn")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    echo -e "${GREEN}[+] No ping (skip host discovery) added${NC}"
    echo -e "${BLUE}Info: Treats all hosts as online, skips ping probes${NC}"
    echo -e "${YELLOW}Uses: When ping is blocked, stealth scanning${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_arp_ping() {
    CURRENT_FLAGS+=("-PR")
    
    echo -e "${GREEN}[+] ARP ping added${NC}"
    echo -e "${BLUE}Info: Uses ARP requests for host discovery (LAN only)${NC}"
    echo -e "${YELLOW}Uses: Local network discovery, most reliable on LAN${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# STEALTH & EVASION 
add_fragment_packets() {
    CURRENT_FLAGS+=("-f")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    echo -e "${GREEN}[+] Packet fragmentation added${NC}"
    echo -e "${BLUE}Info: Splits packets to evade simple packet filters${NC}"
    echo -e "${YELLOW}Uses: Bypassing basic firewalls and IDS${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_decoy_scan() {
    local decoys="$1"
    
    if [ -z "$decoys" ]; then
        echo -e "${RED}Usage: stealth decoy <ip1,ip2,ip3>${NC}"
        echo -e "${YELLOW}Example: stealth decoy 192.168.1.5,192.168.1.10,ME${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-D" "$decoys")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 2))
    
    echo -e "${GREEN}[+] Decoy scan added: $decoys${NC}"
    echo -e "${BLUE}Info: Hides your IP among fake decoy addresses${NC}"
    echo -e "${YELLOW}Uses: Making it hard to identify real scanner${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_source_port() {
    local port="$1"
    
    if [ -z "$port" ]; then
        echo -e "${RED}Usage: stealth source-port <port>${NC}"
        echo -e "${YELLOW}Example: stealth source-port 53 (DNS port)${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--source-port" "$port")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    echo -e "${GREEN}[+] Source port set to: $port${NC}"
    echo -e "${BLUE}Info: Scans appear to come from trusted port${NC}"
    echo -e "${YELLOW}Uses: Bypassing simple port-based filters${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_randomize_hosts() {
    CURRENT_FLAGS+=("--randomize-hosts")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    echo -e "${GREEN}[+] Host randomization added${NC}"
    echo -e "${BLUE}Info: Scans targets in random order${NC}"
    echo -e "${YELLOW}Uses: Avoiding predictable scan patterns${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_scan_delay() {
    local delay="$1"
    
    if [ -z "$delay" ]; then
        echo -e "${RED}Usage: stealth delay <time>${NC}"
        echo -e "${YELLOW}Example: stealth delay 5s (5 second delay)${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--scan-delay" "$delay")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 2))
    
    echo -e "${GREEN}[+] Scan delay set to: $delay${NC}"
    echo -e "${BLUE}Info: Adds delay between probes${NC}"
    echo -e "${YELLOW}Uses: Avoiding rate-based detection${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# OUTPUT OPTIONS
add_output_normal() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        echo -e "${RED}Usage: output normal <filename>${NC}"
        echo -e "${YELLOW}Example: output normal scan_results.txt${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-oN" "$filename")
    OUTPUT_FILE="$filename"
    
    echo -e "${GREEN}[+] Normal output added: $filename${NC}"
    echo -e "${BLUE}Info: Human-readable text format${NC}"
    echo -e "${YELLOW}Uses: Easy reading, reporting${NC}"
}

add_output_xml() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        echo -e "${RED}Usage: output xml <filename>${NC}"
        echo -e "${YELLOW}Example: output xml scan_results.xml${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-oX" "$filename")
    OUTPUT_FILE="$filename"
    
    echo -e "${GREEN}[+] XML output added: $filename${NC}"
    echo -e "${BLUE}Info: Structured XML format${NC}"
    echo -e "${YELLOW}Uses: Tool integration, parsing${NC}"
}

add_output_grepable() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        echo -e "${RED}Usage: output grepable <filename>${NC}"
        echo -e "${YELLOW}Example: output grepable scan_results.gnmap${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-oG" "$filename")
    OUTPUT_FILE="$filename"
    
    echo -e "${GREEN}[+] Grepable output added: $filename${NC}"
    echo -e "${BLUE}Info: Single-line format easy to grep${NC}"
    echo -e "${YELLOW}Uses: Quick filtering, scripting${NC}"
}

add_output_all() {
    local basename="$1"
    
    if [ -z "$basename" ]; then
        echo -e "${RED}Usage: output all <basename>${NC}"
        echo -e "${YELLOW}Example: output all scan_results${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-oA" "$basename")
    OUTPUT_FILE="$basename.*"
    
    echo -e "${GREEN}[+] All formats output added: $basename${NC}"
    echo -e "${BLUE}Info: Creates .nmap, .xml, and .gnmap files${NC}"
    echo -e "${YELLOW}Uses: Maximum compatibility with all tools${NC}"
}

add_verbose() {
    local level="$1"
    
    if [ -z "$level" ]; then
        level="1"
    fi
    
    if [ "$level" = "1" ]; then
        CURRENT_FLAGS+=("-v")
        echo -e "${GREEN}[+] Verbose mode added${NC}"
        echo -e "${BLUE}Info: Shows more details during scan${NC}"
    elif [ "$level" = "2" ]; then
        CURRENT_FLAGS+=("-vv")
        echo -e "${GREEN}[+] Extra verbose mode added${NC}"
        echo -e "${BLUE}Info: Shows maximum details during scan${NC}"
    else
        echo -e "${RED}Usage: verbose [1|2]${NC}"
        echo -e "${YELLOW}1=verbose, 2=extra verbose${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Uses: Real-time progress monitoring${NC}"
}

# SERVICE ENUMERATION 
add_web_enum() {
    CURRENT_FLAGS+=("--script" "http-enum,http-headers,http-methods,http-title")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 2))
    
    echo -e "${GREEN}[+] Web enumeration scripts added${NC}"
    echo -e "${BLUE}Info: HTTP/HTTPS service enumeration and info gathering${NC}"
    echo -e "${YELLOW}Uses: Web server fingerprinting, directory discovery${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_smb_enum() {
    CURRENT_FLAGS+=("--script" "smb-enum-shares,smb-enum-users,smb-os-discovery")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 2))
    
    echo -e "${GREEN}[+] SMB enumeration scripts added${NC}"
    echo -e "${BLUE}Info: Windows SMB/NetBIOS service enumeration${NC}"
    echo -e "${YELLOW}Uses: Share discovery, user enumeration, OS detection${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_ssh_enum() {
    CURRENT_FLAGS+=("--script" "ssh-hostkey,ssh2-enum-algos")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 1))
    
    echo -e "${GREEN}[+] SSH enumeration scripts added${NC}"
    echo -e "${BLUE}Info: SSH service fingerprinting and algorithm detection${NC}"
    echo -e "${YELLOW}Uses: SSH version detection, security assessment${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_ftp_enum() {
    CURRENT_FLAGS+=("--script" "ftp-anon,ftp-banner")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 1))
    
    echo -e "${GREEN}[+] FTP enumeration scripts added${NC}"
    echo -e "${BLUE}Info: FTP service banner and anonymous access check${NC}"
    echo -e "${YELLOW}Uses: FTP version detection, anonymous login testing${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_dns_enum() {
    CURRENT_FLAGS+=("--script" "dns-zone-transfer,dns-service-discovery")
    DETECTION_LEVEL=$((DETECTION_LEVEL + 1))
    
    echo -e "${GREEN}[+] DNS enumeration scripts added${NC}"
    echo -e "${BLUE}Info: DNS zone transfer and service discovery${NC}"
    echo -e "${YELLOW}Uses: Domain enumeration, DNS server testing${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# TARGET MANAGEMENT 
add_target_file() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        echo -e "${RED}Usage: target file <filename>${NC}"
        echo -e "${YELLOW}Example: target file targets.txt${NC}"
        return 1
    fi
    
    if [ ! -f "$filename" ]; then
        echo -e "${RED}Error: File '$filename' not found${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("-iL" "$filename")
    TARGET="file:$filename"
    
    echo -e "${GREEN}[+] Target file added: $filename${NC}"
    echo -e "${BLUE}Info: Will scan all targets listed in the file${NC}"
    echo -e "${YELLOW}Uses: Batch scanning multiple targets${NC}"
}

add_exclude_hosts() {
    local hosts="$1"
    
    if [ -z "$hosts" ]; then
        echo -e "${RED}Usage: exclude <host1,host2> or exclude file <filename>${NC}"
        echo -e "${YELLOW}Example: exclude 192.168.1.1,192.168.1.5${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--exclude" "$hosts")
    
    echo -e "${GREEN}[+] Excluded hosts: $hosts${NC}"
    echo -e "${BLUE}Info: These hosts will be skipped during scan${NC}"
    echo -e "${YELLOW}Uses: Avoiding critical systems, authorized exclusions${NC}"
}

validate_cidr() {
    local cidr="$1"
    
    # Check if it has a slash
    if [[ ! "$cidr" == *"/"* ]]; then
        echo -e "${RED}Invalid CIDR: Missing '/' notation${NC}"
        return 1
    fi
    
    # Split IP and prefix
    local ip="${cidr%/*}"
    local prefix="${cidr#*/}"
    
    # Check if prefix is a number between 0-32
    if ! [[ "$prefix" =~ ^[0-9]+$ ]] || [ "$prefix" -lt 0 ] || [ "$prefix" -gt 32 ]; then
        echo -e "${RED}Invalid CIDR: Prefix must be 0-32${NC}"
        return 1
    fi
    
    # Basic IP format check
    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}Invalid CIDR: Invalid IP format${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Valid CIDR notation: $cidr${NC}"
    return 0
}

validate_ip_range() {
    local range="$1"
    
    # Check if it has a dash
    if [[ ! "$range" == *"-"* ]]; then
        echo -e "${RED}Invalid range: Missing '-' notation${NC}"
        return 1
    fi
    
    # Split start and end
    local start="${range%-*}"
    local end="${range#*-}"
    
    # Basic format checks
    if [[ ! "$start" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}Invalid range: Start IP format invalid${NC}"
        return 1
    fi
    
    # End might be just last octet
    if [[ "$end" =~ ^[0-9]+$ ]]; then
        echo -e "${GREEN}Valid IP range: $range${NC}"
        return 0
    elif [[ "$end" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${GREEN}Valid IP range: $range${NC}"
        return 0
    else
        echo -e "${RED}Invalid range: End format invalid${NC}"
        return 1
    fi
}

# FIREWALL EVASION
add_mtu_size() {
    local mtu="$1"
    
    if [ -z "$mtu" ]; then
        echo -e "${RED}Usage: stealth mtu <size>${NC}"
        echo -e "${YELLOW}Example: stealth mtu 1500${NC}"
        return 1
    fi
    
    # Check if MTU is a number
    if ! [[ "$mtu" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid MTU: Must be a number${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--mtu" "$mtu")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    echo -e "${GREEN}[+] MTU size set to: $mtu${NC}"
    echo -e "${BLUE}Info: Custom packet size to evade detection${NC}"
    echo -e "${YELLOW}Uses: Bypassing MTU-based filtering${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

add_spoof_mac() {
    local mac="$1"
    
    if [ -z "$mac" ]; then
        echo -e "${RED}Usage: stealth spoof-mac <mac_address>${NC}"
        echo -e "${YELLOW}Example: stealth spoof-mac 00:11:22:33:44:55${NC}"
        echo -e "${YELLOW}Or use: stealth spoof-mac random${NC}"
        return 1
    fi
    
    CURRENT_FLAGS+=("--spoof-mac" "$mac")
    DETECTION_LEVEL=$((DETECTION_LEVEL - 1))
    
    if [ "$mac" = "random" ]; then
        echo -e "${GREEN}[+] Random MAC spoofing added${NC}"
        echo -e "${BLUE}Info: Uses random MAC address${NC}"
    else
        echo -e "${GREEN}[+] MAC spoofing added: $mac${NC}"
        echo -e "${BLUE}Info: Hides real MAC address${NC}"
    fi
    
    echo -e "${YELLOW}Uses: Avoiding MAC-based tracking and filtering${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# COMMAND BUILDING
build_command() {
    echo -e "${CYAN}═══════════ BUILT COMMAND ═══════════${NC}"
    echo
    
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] Error: No target specified${NC}"
        echo -e "${YELLOW}Use: target <ip/hostname/cidr>${NC}"
        return 1
    fi
    
    local final_command="nmap ${CURRENT_FLAGS[*]} $TARGET"
    
    echo -e "${WHITE}Final Command:${NC}"
    echo -e "${GREEN}$final_command${NC}"
    echo
    
    if [ "$DETECTION_LEVEL" -gt 0 ]; then
        show_detection_meter $DETECTION_LEVEL
    fi
    
    if [ -n "$OUTPUT_FILE" ]; then
        echo -e "${BLUE}Output will be saved to: $OUTPUT_FILE${NC}"
    fi
    
    echo -e "${YELLOW}Ready to execute? Type 'execute' to run the scan${NC}"
    echo
}

execute_command() {
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] Error: No target specified${NC}"
        echo -e "${YELLOW}Use 'build' to see the current command first${NC}"
        return 1
    fi
    
    local final_command="nmap ${CURRENT_FLAGS[*]} $TARGET"
    
    echo -e "${CYAN}═══════════ EXECUTING SCAN ═══════════${NC}"
    echo -e "${WHITE}Command: $final_command${NC}"
    echo
    
    if [ "$DETECTION_LEVEL" -gt 3 ]; then
        echo -e "${RED}WARNING: High detection level scan!${NC}"
        echo -e "${YELLOW}Continue? (y/N): ${NC}"
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Scan cancelled${NC}"
            return 0
        fi
    fi
    
    echo -e "${GREEN}Starting nmap scan...${NC}"
    echo
    
    # Execute the actual nmap command
    eval "$final_command"
    
    echo
    echo -e "${GREEN}Scan completed!${NC}"
}

save_command() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        filename="vader_command.txt"
    fi
    
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] Error: No target specified${NC}"
        return 1
    fi
    
    local final_command="nmap ${CURRENT_FLAGS[*]} $TARGET"
    
    echo "$final_command" > "$filename"
    echo -e "${GREEN}[+] Command saved to: $filename${NC}"
    echo -e "${BLUE}Content: $final_command${NC}"
}

reset_command() {
    CURRENT_FLAGS=()
    TARGET=""
    DETECTION_LEVEL=0
    OUTPUT_FILE=""
    
    echo -e "${GREEN}[+] All settings cleared${NC}"
    echo -e "${BLUE}Ready to build a new command${NC}"
    echo -e "${YELLOW}Start with: target <ip/hostname>${NC}"
}

calculate_detection_level() {
    # Simple calculation - just return current level
    # (This is updated by individual functions as they add/remove detection)
    
    if [ "$DETECTION_LEVEL" -lt 0 ]; then
        DETECTION_LEVEL=0
    elif [ "$DETECTION_LEVEL" -gt 5 ]; then
        DETECTION_LEVEL=5
    fi
    
    echo "$DETECTION_LEVEL"
}

show_command_summary() {
    echo -e "${CYAN}═══════════ COMMAND SUMMARY ═══════════${NC}"
    echo
    
    if [ -z "$TARGET" ]; then
        echo -e "${RED}Target: Not set${NC}"
    else
        echo -e "${GREEN}Target: $TARGET${NC}"
    fi
    
    if [ ${#CURRENT_FLAGS[@]} -eq 0 ]; then
        echo -e "${YELLOW}Flags: None set${NC}"
    else
        echo -e "${GREEN}Flags: ${CURRENT_FLAGS[*]}${NC}"
    fi
    
    echo
    echo -e "${BLUE}What this scan does:${NC}"
    
    # Explain what the current flags do
    for flag in "${CURRENT_FLAGS[@]}"; do
        case "$flag" in
            "-sS") echo -e "  • TCP SYN scan (stealth)" ;;
            "-sT") echo -e "  • TCP Connect scan (reliable)" ;;
            "-sU") echo -e "  • UDP scan (slower)" ;;
            "-sV") echo -e "  • Service version detection" ;;
            "-O") echo -e "  • OS detection" ;;
            "-A") echo -e "  • Aggressive scan (all features)" ;;
            "-sC") echo -e "  • Default NSE scripts" ;;
            "-F") echo -e "  • Fast scan (top 100 ports)" ;;
            "-p-") echo -e "  • All ports scan" ;;
            "-Pn") echo -e "  • Skip ping (treat as online)" ;;
            "-f") echo -e "  • Fragment packets (stealth)" ;;
            "-v") echo -e "  • Verbose output" ;;
            "-vv") echo -e "  • Extra verbose output" ;;
        esac
    done
    
    echo
    if [ "$DETECTION_LEVEL" -gt 0 ]; then
        show_detection_meter $DETECTION_LEVEL
    fi
}

# HELP & INFORMATION 
explain_flag() {
    local flag="$1"
    
    if [ -z "$flag" ]; then
        echo -e "${RED}Usage: explain <flag_name>${NC}"
        echo -e "${YELLOW}Example: explain sS${NC}"
        return 1
    fi
    
    echo -e "${CYAN}═══════════ FLAG EXPLANATION ═══════════${NC}"
    echo
    
    case "$flag" in
        "sS"|"-sS")
            echo -e "${GREEN}Flag: -sS (TCP SYN Scan)${NC}"
            echo -e "${BLUE}Description: Half-open scan, sends SYN packets${NC}"
            echo -e "${YELLOW}Detection: 2/5 - Moderate${NC}"
            echo -e "${WHITE}Use when: Default choice, fast and reliable${NC}"
            ;;
        "sT"|"-sT")
            echo -e "${GREEN}Flag: -sT (TCP Connect Scan)${NC}"
            echo -e "${BLUE}Description: Full TCP connection to each port${NC}"
            echo -e "${YELLOW}Detection: 3/5 - High${NC}"
            echo -e "${WHITE}Use when: SYN scan doesn't work, non-root user${NC}"
            ;;
        "sU"|"-sU")
            echo -e "${GREEN}Flag: -sU (UDP Scan)${NC}"
            echo -e "${BLUE}Description: Scans UDP ports (slower than TCP)${NC}"
            echo -e "${YELLOW}Detection: 2/5 - Moderate${NC}"
            echo -e "${WHITE}Use when: Looking for DNS, DHCP, SNMP services${NC}"
            ;;
        "sV"|"-sV")
            echo -e "${GREEN}Flag: -sV (Version Detection)${NC}"
            echo -e "${BLUE}Description: Probes open ports to determine service versions${NC}"
            echo -e "${YELLOW}Detection: 2/5 - Moderate${NC}"
            echo -e "${WHITE}Use when: Need software versions for vulnerability research${NC}"
            ;;
        "O"|"-O")
            echo -e "${GREEN}Flag: -O (OS Detection)${NC}"
            echo -e "${BLUE}Description: Attempts to identify target operating system${NC}"
            echo -e "${YELLOW}Detection: 3/5 - High${NC}"
            echo -e "${WHITE}Use when: Need OS fingerprinting for attack planning${NC}"
            ;;
        "A"|"-A")
            echo -e "${GREEN}Flag: -A (Aggressive Scan)${NC}"
            echo -e "${BLUE}Description: Combines -sV, -O, -sC, and --traceroute${NC}"
            echo -e "${YELLOW}Detection: 4/5 - Very High${NC}"
            echo -e "${WHITE}Use when: Need maximum information, stealth not important${NC}"
            ;;
        "sC"|"-sC")
            echo -e "${GREEN}Flag: -sC (Default Scripts)${NC}"
            echo -e "${BLUE}Description: Runs default NSE scripts for enumeration${NC}"
            echo -e "${YELLOW}Detection: 1/5 - Low${NC}"
            echo -e "${WHITE}Use when: Want safe service enumeration${NC}"
            ;;
        "Pn"|"-Pn")
            echo -e "${GREEN}Flag: -Pn (No Ping)${NC}"
            echo -e "${BLUE}Description: Skip host discovery, treat all as online${NC}"
            echo -e "${YELLOW}Detection: Reduces by 1 level${NC}"
            echo -e "${WHITE}Use when: Firewalls block ping, maximum stealth${NC}"
            ;;
        "f"|"-f")
            echo -e "${GREEN}Flag: -f (Fragment Packets)${NC}"
            echo -e "${BLUE}Description: Fragments packets to evade packet filters${NC}"
            echo -e "${YELLOW}Detection: Reduces by 1 level${NC}"
            echo -e "${WHITE}Use when: Bypassing simple firewalls${NC}"
            ;;
        "T0"|"T1"|"T2"|"T3"|"T4"|"T5")
            local timing="${flag#T}"
            echo -e "${GREEN}Flag: -T$timing (Timing Template)${NC}"
            case "$timing" in
                "0") echo -e "${BLUE}Description: Paranoid - 5+ minutes between probes${NC}" ;;
                "1") echo -e "${BLUE}Description: Sneaky - 15 seconds between probes${NC}" ;;
                "2") echo -e "${BLUE}Description: Polite - Less bandwidth intensive${NC}" ;;
                "3") echo -e "${BLUE}Description: Normal - Default nmap timing${NC}" ;;
                "4") echo -e "${BLUE}Description: Aggressive - Fast, assumes good network${NC}" ;;
                "5") echo -e "${BLUE}Description: Insane - Very fast, may miss results${NC}" ;;
            esac
            echo -e "${WHITE}Use when: Need to control scan speed vs stealth${NC}"
            ;;
        *)
            echo -e "${RED}Unknown flag: $flag${NC}"
            echo -e "${YELLOW}Try: sS, sT, sU, sV, O, A, sC, Pn, f, T0-T5${NC}"
            return 1
            ;;
    esac
    echo
}

show_examples() {
    local scan_type="$1"
    
    if [ -z "$scan_type" ]; then
        echo -e "${RED}Usage: examples <scan_type>${NC}"
        echo -e "${YELLOW}Available: basic, stealth, vuln, web, discovery${NC}"
        return 1
    fi
    
    echo -e "${CYAN}═══════════ SCAN EXAMPLES ═══════════${NC}"
    echo
    
    case "$scan_type" in
        "basic")
            echo -e "${GREEN}Basic Scan Examples:${NC}"
            echo
            echo -e "${BLUE}Quick scan:${NC}"
            echo -e "  target 192.168.1.1"
            echo -e "  scan syn"
            echo -e "  ports fast"
            echo -e "  execute"
            echo
            echo -e "${BLUE}Version detection:${NC}"
            echo -e "  target 10.0.0.1"
            echo -e "  scan version"
            echo -e "  ports 80,443,22"
            echo -e "  output normal results.txt"
            echo -e "  execute"
            ;;
        "stealth")
            echo -e "${GREEN}Stealth Scan Examples:${NC}"
            echo
            echo -e "${BLUE}Maximum stealth:${NC}"
            echo -e "  target 192.168.1.0/24"
            echo -e "  profile stealth"
            echo -e "  execute"
            echo
            echo -e "${BLUE}Custom stealth:${NC}"
            echo -e "  target 10.0.0.5"
            echo -e "  scan syn"
            echo -e "  stealth timing 1"
            echo -e "  stealth fragment"
            echo -e "  stealth delay 10s"
            echo -e "  execute"
            ;;
        "vuln")
            echo -e "${GREEN}Vulnerability Scan Examples:${NC}"
            echo
            echo -e "${BLUE}Basic vulnerability scan:${NC}"
            echo -e "  target example.com"
            echo -e "  scan version"
            echo -e "  scripts vuln"
            echo -e "  output xml vuln_results.xml"
            echo -e "  execute"
            echo
            echo -e "${BLUE}Comprehensive assessment:${NC}"
            echo -e "  target 192.168.1.100"
            echo -e "  profile vuln"
            echo -e "  execute"
            ;;
        "web")
            echo -e "${GREEN}Web Application Scan Examples:${NC}"
            echo
            echo -e "${BLUE}Web server enumeration:${NC}"
            echo -e "  target web-server.com"
            echo -e "  ports 80,443,8080,8443"
            echo -e "  scripts web"
            echo -e "  verbose on"
            echo -e "  execute"
            echo
            echo -e "${BLUE}SSL/TLS assessment:${NC}"
            echo -e "  target https-site.com"
            echo -e "  ports 443"
            echo -e "  scan version"
            echo -e "  scripts web"
            echo -e "  execute"
            ;;
        "discovery")
            echo -e "${GREEN}Network Discovery Examples:${NC}"
            echo
            echo -e "${BLUE}Live host discovery:${NC}"
            echo -e "  target 192.168.0.0/16"
            echo -e "  scan ping"
            echo -e "  output normal discovery.txt"
            echo -e "  execute"
            echo
            echo -e "${BLUE}Quick network map:${NC}"
            echo -e "  target 10.0.0.0/24"
            echo -e "  profile discovery"
            echo -e "  execute"
            ;;
        *)
            echo -e "${RED}Unknown scan type: $scan_type${NC}"
            echo -e "${YELLOW}Available types: basic, stealth, vuln, web, discovery${NC}"
            return 1
            ;;
    esac
    echo
    echo -e "${YELLOW}Tip: Copy and paste these commands into VADER!${NC}"
    echo
}

show_detection_info() {
    echo -e "${CYAN}═══════════ DETECTION LEVELS EXPLAINED ═══════════${NC}"
    echo
    echo -e "${YELLOW}VADER uses a 0-5 scale to show how detectable your scan is:${NC}"
    echo
    
    echo -e "${GREEN}[●○○○○] 0/5 - Ghost Mode${NC}"
    echo -e "${BLUE}  • Extremely hard to detect${NC}"
    echo -e "${BLUE}  • Uses advanced evasion techniques${NC}"
    echo -e "${BLUE}  • Examples: T0 timing, idle scans${NC}"
    echo
    
    echo -e "${GREEN}[●●○○○] 1/5 - Very Low${NC}"
    echo -e "${BLUE}  • Rarely triggers alerts${NC}"
    echo -e "${BLUE}  • Looks like normal network traffic${NC}"
    echo -e "${BLUE}  • Examples: Ping scans, SSH enum${NC}"
    echo
    
    echo -e "${YELLOW}[●●●○○] 2/5 - Low${NC}"
    echo -e "${BLUE}  • Basic monitoring might notice${NC}"
    echo -e "${BLUE}  • Still fairly stealthy${NC}"
    echo -e "${BLUE}  • Examples: SYN scans, version detection${NC}"
    echo
    
    echo -e "${YELLOW}[●●●●○] 3/5 - Medium${NC}"
    echo -e "${BLUE}  • Will likely be logged${NC}"
    echo -e "${BLUE}  • Security teams may investigate${NC}"
    echo -e "${BLUE}  • Examples: Connect scans, OS detection${NC}"
    echo
    
    echo -e "${RED}[●●●●●] 4/5 - High${NC}"
    echo -e "${BLUE}  • Definitely detected and logged${NC}"
    echo -e "${BLUE}  • May trigger immediate alerts${NC}"
    echo -e "${BLUE}  • Examples: Aggressive scans, vuln scripts${NC}"
    echo
    
    echo -e "${RED}[●●●●●] 5/5 - Maximum${NC}"
    echo -e "${BLUE}  • Alarms will definitely trigger${NC}"
    echo -e "${BLUE}  • Security response expected${NC}"
    echo -e "${BLUE}  • Examples: T5 timing, all ports, exploit scripts${NC}"
    echo
    
    echo -e "${CYAN}═══════════ TIPS FOR STAYING STEALTHY ═══════════${NC}"
    echo
    echo -e "${GREEN}Reduce Detection:${NC}"
    echo -e "${BLUE}  • Use slower timing templates (T0, T1)${NC}"
    echo -e "${BLUE}  • Fragment packets with -f flag${NC}"
    echo -e "${BLUE}  • Add scan delays between probes${NC}"
    echo -e "${BLUE}  • Use decoy scans to hide your IP${NC}"
    echo -e "${BLUE}  • Skip ping discovery (-Pn)${NC}"
    echo -e "${BLUE}  • Randomize target order${NC}"
    echo
    echo -e "${YELLOW}Increase Speed (Higher Detection):${NC}"
    echo -e "${BLUE}  • Use faster timing (T4, T5)${NC}"
    echo -e "${BLUE}  • Scan all ports (-p-)${NC}"
    echo -e "${BLUE}  • Run vulnerability scripts${NC}"
    echo -e "${BLUE}  • Use aggressive scans (-A)${NC}"
    echo
    echo -e "${RED}Remember: Always have proper authorization before scanning!${NC}"
    echo
    echo -e "${WHITE}Your current scan detection level will be shown after each command.${NC}"
    echo
}

# === INTERACTIVE MODE ===
interactive_mode() {
    echo -e "${GREEN}Welcome to VADER Interactive Mode!${NC}"
    echo -e "${BLUE}Type 'help' for commands or 'exit' to quit${NC}"
    echo
    
    while true; do
        # Show current status if we have a target
        if [ -n "$TARGET" ]; then
            echo -e "${CYAN}Target: $TARGET${NC} | ${YELLOW}Flags: ${#CURRENT_FLAGS[@]}${NC} | ${GREEN}Detection: $DETECTION_LEVEL/5${NC}"
        fi
        
        # Show prompt
        echo -ne "${WHITE}VADER> ${NC}"
        
        # Read user input
        read -r user_input
        
        # Skip empty input
        if [ -z "$user_input" ]; then
            continue
        fi
        
        # Parse and execute command
        parse_command "$user_input"
        
        echo
    done
}

handle_target_input() {
    echo -e "${YELLOW}═══════════ TARGET SETUP ═══════════${NC}"
    echo
    echo -e "${BLUE}Enter your target (IP, hostname, CIDR, or range):${NC}"
    echo -e "${GREEN}Examples:${NC}"
    echo -e "  Single IP: 192.168.1.1"
    echo -e "  Hostname: google.com"
    echo -e "  CIDR: 192.168.1.0/24"
    echo -e "  Range: 192.168.1.1-50"
    echo -e "  File: file targets.txt"
    echo
    
    while true; do
        echo -ne "${WHITE}Target> ${NC}"
        read -r target_input
        
        # Check if user wants to cancel
        if [[ "$target_input" =~ ^(exit|quit|cancel)$ ]]; then
            echo -e "${YELLOW}Target setup cancelled${NC}"
            return 1
        fi
        
        # Check for empty input
        if [ -z "$target_input" ]; then
            echo -e "${RED}Please enter a target${NC}"
            continue
        fi
        
        # Handle file input
        if [[ "$target_input" == file* ]]; then
            local filename=$(echo "$target_input" | awk '{print $2}')
            add_target_file "$filename"
            if [ $? -eq 0 ]; then
                break
            else
                continue
            fi
        fi
        
        # Validate target
        if validate_target "$target_input"; then
            TARGET="$target_input"
            echo -e "${GREEN}[+] Target set successfully!${NC}"
            echo
            
            # Ask if they want to continue with scan setup
            echo -e "${BLUE}Ready to configure scan options?${NC}"
            echo -e "${YELLOW}Next steps: scan type, ports, scripts, etc.${NC}"
            echo -e "${WHITE}Type 'help' to see all options${NC}"
            echo
            break
        else
            echo -e "${RED}Invalid target format. Please try again.${NC}"
            continue
        fi
    done
    
    return 0
}

handle_scan_selection() {
    echo -e "${YELLOW}═══════════ SCAN TYPE SELECTION ═══════════${NC}"
    echo
    echo -e "${BLUE}Choose your scan type:${NC}"
    echo
    echo -e "${GREEN}1.${NC} TCP SYN Scan     - Fast and stealthy (Default)"
    echo -e "${GREEN}2.${NC} TCP Connect Scan - Reliable, works without root"
    echo -e "${GREEN}3.${NC} UDP Scan         - For UDP services (DNS, DHCP)"
    echo -e "${GREEN}4.${NC} Ping Scan        - Host discovery only"
    echo -e "${GREEN}5.${NC} Version Scan     - Detect service versions"
    echo -e "${GREEN}6.${NC} OS Scan          - Identify operating system"
    echo -e "${GREEN}7.${NC} Aggressive Scan  - Maximum information gathering"
    echo -e "${GREEN}8.${NC} Stealth SYN      - Maximum stealth configuration"
    echo
    echo -e "${CYAN}Or use quick profiles:${NC}"
    echo -e "${GREEN}9.${NC} Quick Profile    - Fast basic scan"
    echo -e "${GREEN}10.${NC} Stealth Profile - Maximum stealth"
    echo -e "${GREEN}11.${NC} Vuln Profile    - Vulnerability assessment"
    echo
    
    while true; do
        echo -ne "${WHITE}Select (1-11 or 'back'): ${NC}"
        read -r choice
        
        # Handle back/cancel
        if [[ "$choice" =~ ^(back|cancel|exit)$ ]]; then
            echo -e "${YELLOW}Scan selection cancelled${NC}"
            return 1
        fi
        
        # Handle the selection
        case "$choice" in
            1)
                add_tcp_syn_scan
                break
                ;;
            2)
                add_tcp_connect_scan
                break
                ;;
            3)
                add_udp_scan
                break
                ;;
            4)
                add_ping_scan
                break
                ;;
            5)
                add_version_scan
                break
                ;;
            6)
                add_os_scan
                break
                ;;
            7)
                add_aggressive_scan
                break
                ;;
            8)
                add_stealth_syn_scan
                break
                ;;
            9)
                quick_scan_profile
                break
                ;;
            10)
                stealth_scan_profile
                break
                ;;
            11)
                vulnerability_scan_profile
                break
                ;;
            "")
                echo -e "${YELLOW}Please make a selection${NC}"
                continue
                ;;
            *)
                echo -e "${RED}Invalid choice. Please select 1-11${NC}"
                continue
                ;;
        esac
    done
    
    echo
    echo -e "${GREEN}[+] Scan type configured!${NC}"
    echo -e "${BLUE}Next steps: Configure ports, scripts, stealth options${NC}"
    echo -e "${YELLOW}Type 'help' to see all available commands${NC}"
    echo
    
    return 0
}

# === QUICK SCAN PROFILES ===
quick_scan_profile() {
    # Reset current flags and set quick scan
    CURRENT_FLAGS=("-sS" "-F")
    DETECTION_LEVEL=2
    
    echo -e "${GREEN}[+] Quick scan profile loaded${NC}"
    echo -e "${BLUE}Profile: TCP SYN scan + Fast port scan (top 100 ports)${NC}"
    echo -e "${YELLOW}Best for: Initial reconnaissance, fast results${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

stealth_scan_profile() {
    # Reset current flags and set stealth scan
    CURRENT_FLAGS=("-sS" "-T1" "-f" "--scan-delay" "10s")
    DETECTION_LEVEL=1
    
    echo -e "${GREEN}[+] Stealth scan profile loaded${NC}"
    echo -e "${BLUE}Profile: SYN scan + Slow timing + Fragmentation + Delays${NC}"
    echo -e "${YELLOW}Best for: Avoiding detection, bypassing basic IDS${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

comprehensive_scan_profile() {
    # Reset current flags and set comprehensive scan
    CURRENT_FLAGS=("-sS" "-sV" "-O" "-sC" "-p-")
    DETECTION_LEVEL=4
    
    echo -e "${GREEN}[+] Comprehensive scan profile loaded${NC}"
    echo -e "${BLUE}Profile: SYN + Version + OS + Scripts + All ports${NC}"
    echo -e "${YELLOW}Best for: Complete system assessment${NC}"
    echo -e "${RED}Warning: This scan will be very noticeable and take time!${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

vulnerability_scan_profile() {
    # Reset current flags and set vulnerability scan
    CURRENT_FLAGS=("-sS" "-sV" "--script" "vuln")
    DETECTION_LEVEL=3
    
    echo -e "${GREEN}[+] Vulnerability scan profile loaded${NC}"
    echo -e "${BLUE}Profile: SYN scan + Version detection + Vulnerability scripts${NC}"
    echo -e "${YELLOW}Best for: Security assessment, finding known CVEs${NC}"
    echo -e "${RED}Warning: Actively probes for vulnerabilities!${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

discovery_scan_profile() {
    # Reset current flags and set discovery scan
    CURRENT_FLAGS=("-sn")
    DETECTION_LEVEL=1
    
    echo -e "${GREEN}[+] Discovery scan profile loaded${NC}"
    echo -e "${BLUE}Profile: Ping scan only (no port scanning)${NC}"
    echo -e "${YELLOW}Best for: Network mapping, finding live hosts${NC}"
    
    show_detection_meter $DETECTION_LEVEL
}

# === VALIDATION ===
validate_port() {
    local port="$1"
    
    # Check if port is empty
    if [ -z "$port" ]; then
        echo -e "${RED}Error: Port cannot be empty${NC}"
        return 1
    fi
    
    # Check if port is a number
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Port must be a number${NC}"
        return 1
    fi
    
    # Check if port is in valid range
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo -e "${RED}Error: Port must be between 1-65535${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Valid port: $port${NC}"
    return 0
}

validate_timing() {
    local timing="$1"
    
    # Check if timing is empty
    if [ -z "$timing" ]; then
        echo -e "${RED}Error: Timing value cannot be empty${NC}"
        return 1
    fi
    
    # Check if timing is a number
    if ! [[ "$timing" =~ ^[0-5]$ ]]; then
        echo -e "${RED}Error: Timing must be 0-5${NC}"
        echo -e "${YELLOW}0=Paranoid, 1=Sneaky, 2=Polite, 3=Normal, 4=Aggressive, 5=Insane${NC}"
        return 1
    fi
    
    # Show what this timing means
    case "$timing" in
        0) echo -e "${GREEN}Valid timing: T0 (Paranoid)${NC}" ;;
        1) echo -e "${GREEN}Valid timing: T1 (Sneaky)${NC}" ;;
        2) echo -e "${GREEN}Valid timing: T2 (Polite)${NC}" ;;
        3) echo -e "${GREEN}Valid timing: T3 (Normal)${NC}" ;;
        4) echo -e "${GREEN}Valid timing: T4 (Aggressive)${NC}" ;;
        5) echo -e "${GREEN}Valid timing: T5 (Insane)${NC}" ;;
    esac
    
    return 0
}

# ERROR HANDLING
handle_error() {
    local error_msg="$1"
    
    # Check if error message is empty
    if [ -z "$error_msg" ]; then
        error_msg="Unknown error occurred"
    fi
    
    echo -e "${RED}[ERROR] $error_msg${NC}"
    echo -e "${YELLOW}Type 'help' for available commands${NC}"
    echo
    
    # Log error with timestamp (simple logging)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $error_msg" >> vader_errors.log
}

# === ESSENTIAL UTILITIES ===
show_open_ports() {
    CURRENT_FLAGS+=("--open")
    
    echo -e "${GREEN}[+] Show open ports only${NC}"
    echo -e "${BLUE}Info: Filters results to display only open ports${NC}"
    echo -e "${YELLOW}Uses: Cleaner output, focus on accessible services${NC}"
}

add_reason() {
    CURRENT_FLAGS+=("--reason")
    
    echo -e "${GREEN}[+] Port state reasoning added${NC}"
    echo -e "${BLUE}Info: Shows why nmap determined each port's state${NC}"
    echo -e "${YELLOW}Uses: Understanding scan results, troubleshooting${NC}"
}

add_packet_trace() {
    CURRENT_FLAGS+=("--packet-trace")
    
    echo -e "${GREEN}[+] Packet tracing added${NC}"
    echo -e "${BLUE}Info: Shows all packets sent and received${NC}"
    echo -e "${YELLOW}Uses: Debugging scans, learning how nmap works${NC}"
    echo -e "${RED}Warning: Very verbose output!${NC}"
}

# === BASIC REPORTING ===
generate_simple_report() {
    local input_file="$1"
    local output_file="$2"
    
    if [ -z "$input_file" ]; then
        echo -e "${RED}Usage: report <input_file> [output_file]${NC}"
        echo -e "${YELLOW}Example: report scan_results.xml simple_report.txt${NC}"
        return 1
    fi
    
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}Error: Input file '$input_file' not found${NC}"
        return 1
    fi
    
    if [ -z "$output_file" ]; then
        output_file="vader_report.txt"
    fi
    
    echo -e "${GREEN}[+] Generating simple report...${NC}"
    
    # Create report header
    {
        echo "═══════════════════════════════════════"
        echo "         VADER SCAN REPORT"
        echo "═══════════════════════════════════════"
        echo "Generated: $(date)"
        echo "Input file: $input_file"
        echo "═══════════════════════════════════════"
        echo
    } > "$output_file"
    
    # Extract key information from nmap output
    if [[ "$input_file" == *.xml ]]; then
        # Handle XML files (basic extraction)
        echo "Processing XML file..." >> "$output_file"
        grep -i "host" "$input_file" | head -5 >> "$output_file" 2>/dev/null || echo "XML parsing requires additional tools" >> "$output_file"
    else
        # Handle text files
        echo "SCAN SUMMARY:" >> "$output_file"
        echo "─────────────" >> "$output_file"
        
        # Extract host information
        grep -i "nmap scan report" "$input_file" >> "$output_file" 2>/dev/null
        
        echo "" >> "$output_file"
        echo "OPEN PORTS:" >> "$output_file"
        echo "───────────" >> "$output_file"
        
        # Extract open ports
        grep "/tcp.*open\|/udp.*open" "$input_file" >> "$output_file" 2>/dev/null
        
        echo "" >> "$output_file"
        echo "SERVICES DETECTED:" >> "$output_file"
        echo "──────────────────" >> "$output_file"
        
        # Extract service information
        grep -i "service info\|version" "$input_file" | head -10 >> "$output_file" 2>/dev/null
    fi
    
    # Add footer
    {
        echo ""
        echo "═══════════════════════════════════════"
        echo "End of VADER Report"
        echo "═══════════════════════════════════════"
    } >> "$output_file"
    
    echo -e "${GREEN}[+] Report generated: $output_file${NC}"
    echo -e "${BLUE}Info: Basic summary of scan results${NC}"
    echo -e "${YELLOW}Uses: Quick overview, sharing findings${NC}"
}

# === COMMAND LINE PARSING ===
parse_arguments() {
    # Simple argument parsing
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -t|--target)
                if [ -z "$2" ]; then
                    echo -e "${RED}Error: --target requires a value${NC}"
                    exit 1
                fi
                TARGET="$2"
                echo -e "${GREEN}Target set to: $TARGET${NC}"
                shift 2
                ;;
            --quick)
                quick_scan_profile
                echo -e "${BLUE}Quick scan profile loaded${NC}"
                shift
                ;;
            --stealth)
                stealth_scan_profile
                echo -e "${BLUE}Stealth scan profile loaded${NC}"
                shift
                ;;
            --vuln)
                vulnerability_scan_profile
                echo -e "${BLUE}Vulnerability scan profile loaded${NC}"
                shift
                ;;
            --interactive)
                # Force interactive mode (default anyway)
                shift
                ;;
            "")
                # Empty argument, skip
                shift
                ;;
            *)
                echo -e "${RED}Unknown argument: $1${NC}"
                echo -e "${YELLOW}Use --help for available options${NC}"
                exit 1
                ;;
        esac
    done
}

show_version() {
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${RED}██╗   ██╗ █████╗ ██████╗ ███████╗██████╗ ${NC}"
    echo -e "${RED}██║   ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗${NC}"
    echo -e "${RED}██║   ██║███████║██║  ██║█████╗  ██████╔╝${NC}"
    echo -e "${RED}╚██╗ ██╔╝██╔══██║██║  ██║██╔══╝  ██╔══██╗${NC}"
    echo -e "${RED} ╚████╔╝ ██║  ██║██████╔╝███████╗██║  ██║${NC}"
    echo -e "${RED}  ╚═══╝  ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo
    echo -e "${WHITE}VADER - Advanced Nmap Command Builder${NC}"
    echo -e "${GREEN}Version: 1.3${NC}"
    echo -e "${BLUE}Author: Ahmad Kamal${NC}"
    echo -e "${YELLOW}License: Educational Use Only${NC}"
    echo
    echo -e "${CYAN}Features:${NC}"
    echo -e "${WHITE}  • Interactive command building${NC}"
    echo -e "${WHITE}  • Detection level awareness${NC}"
    echo -e "${WHITE}  • Stealth and evasion options${NC}"
    echo -e "${WHITE}  • Service-specific enumeration${NC}"
    echo -e "${WHITE}  • Quick scan profiles${NC}"
    echo -e "${WHITE}  • Simple report generation${NC}"
    echo
    echo -e "${CYAN}Usage:${NC}"
    echo -e "${WHITE}  ./vader.sh                    ${NC}- Interactive mode"
    echo -e "${WHITE}  ./vader.sh --target <ip>      ${NC}- Set target and start"
    echo -e "${WHITE}  ./vader.sh --quick --target <ip>  ${NC}- Quick scan"
    echo -e "${WHITE}  ./vader.sh --help             ${NC}- Show help"
    echo
    echo -e "${RED}Remember: Only scan systems you own or have permission to test!${NC}"
    echo
}

# === MAIN FUNCTION ===
main() {
    # Check if nmap is installed
    if ! command -v nmap &> /dev/null; then
        echo -e "${RED}Error: nmap is not installed or not in PATH${NC}"
        echo -e "${YELLOW}Please install nmap first:${NC}"
        echo -e "${WHITE}  Ubuntu/Debian: sudo apt install nmap${NC}"
        echo -e "${WHITE}  CentOS/RHEL:   sudo yum install nmap${NC}"
        echo -e "${WHITE}  macOS:         brew install nmap${NC}"
        exit 1
    fi
    
    # Check if running as root for certain scan types
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}Note: Not running as root. Some scan types may not work.${NC}"
        echo -e "${BLUE}For full functionality, run: sudo ./vader.sh${NC}"
        echo
    fi
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Show banner
    show_banner
    
    # If target was set via command line, show current status
    if [ -n "$TARGET" ]; then
        echo -e "${GREEN}Command line target detected: $TARGET${NC}"
        display_current_command
    fi
    
    # Check if profiles were loaded via command line
    if [ ${#CURRENT_FLAGS[@]} -gt 0 ]; then
        echo -e "${BLUE}Command line profile loaded with ${#CURRENT_FLAGS[@]} flags${NC}"
        echo -e "${YELLOW}Ready to execute or modify further${NC}"
        echo
    fi
    
    # Start interactive mode
    echo -e "${CYAN}Starting interactive mode...${NC}"
    echo -e "${WHITE}Type 'help' for commands or 'exit' to quit${NC}"
    echo
    
    interactive_mode
}

# Trap for clean exit
trap 'echo -e "\n${YELLOW}VADER shutting down...${NC}"; exit 0' INT

# Start the program
main "$@"