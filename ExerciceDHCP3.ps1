<#
==========================================================================
Description : Gérer le service DHCP

Auteur : Noah Froment
Date : 11/12/2024

Version : 3
==========================================================================
#>

# Importer la bibliothèque Visual Basic de Microsoft
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# Demander les informations à l'utilisateur
$nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("Le nom de l'étendue", "Ajout d'étendue", "")

$reseauAdd = [Microsoft.VisualBasic.Interaction]::InputBox("L'adresse IP du réseau", "Ajout d'étendue", "")
$masqueReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Le masque du réseau", "Ajout d'étendue", "")
$passerelle = [Microsoft.VisualBasic.Interaction]::InputBox("La passerelle du réseau", "Ajout d'étendue", "")

$premierAdd = [Microsoft.VisualBasic.Interaction]::InputBox("Le premier Host du réseau", "Ajout d'étendue", "")
$dernierAdd = [Microsoft.VisualBasic.Interaction]::InputBox("Le dernier host du réseau", "Ajout d'étendue", "")

$nomDNS = [Microsoft.VisualBasic.Interaction]::InputBox("Le nom du domaine", "Ajout d'étendue", "")
$dnsAdd = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse DNS", "Ajout d'étendue", "")

# Afficher les informations de l'étendue
Write-Output @"
--------------------------------------------------------------
Voici les informations de l'étendue que vous voulez ajouter !

            Nom de l'étendue : $nomEtendue

            Adresse Réseau : $reseauAdd
            Masque : $masqueReseau
            Passerelle : $passerelle

            Premier Hôte : $premierAdd
            Dernier Hôte : $dernierAdd

            Domaine : $nomDNS
            Adresse DNS : $dnsAdd

--------------------------------------------------------------
                    Ajouter ? y/n
"@

# Demander la confirmation de l'utilisateur
$confirmation = [string](Read-Host)

if ($confirmation -eq "y") {
    Write-Output "Ajout de l'étendue en cours ..."
    try {
        # Créer l'étendue DHCP
        Add-DhcpServerv4Scope -name $nomEtendue -StartRange $premierAdd -EndRange $dernierAdd -SubnetMask $masqueReseau -State Active
        Set-DhcpServerv4OptionValue -OptionID 3 -Value $passerelle -ScopeID $reseauAdd
        Set-DhcpServerv4OptionValue -DnsDomain $nomDNS -DnsServer $dnsAdd
        Write-Output "L'étendue a été ajoutée avec succès."
    } catch {
        Write-Output "Erreur lors de l'ajout de l'étendue : $_"
    }
} else {
    Write-Output "Opération annulée par l'utilisateur."
    exit
}
