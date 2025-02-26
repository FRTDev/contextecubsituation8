<#
==========================================================================
Description : Gérer le service DHCP

Auteur : FRTDev
Date : 11/12/2024

Version : 1
==========================================================================
#>

# Demander les informations à l'utilisateur
$nomEtendue = [string](Read-Host "Le nom de l'étendue")

$reseauAdd = [ipaddress](Read-Host "L'adresse IP du réseau")
$masqueReseau = [ipaddress](Read-Host "Le masque du réseau")
$passerelle = [ipaddress](Read-Host "La passerelle du réseau")

$premierAdd = [ipaddress](Read-Host "Le premier Host du réseau")
$dernierAdd = [ipaddress](Read-Host "Le dernier host du réseau")

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
        Write-Output "L'étendue a été ajoutée avec succès."
    } catch {
        Write-Output "Erreur lors de l'ajout de l'étendue : $_"
    }
} else {
    Write-Output "Opération annulée par l'utilisateur."
    exit
}
