<#
==========================================================================
Description : Gérer le service DHCP

Auteur : FRTDev
Date : 11/12/2024

Version : 5
==========================================================================
#>

# Importer la bibliothèque Visual Basic de Microsoft
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# Demander le nombre d'étendues à créer
$nombreEtendues = [int][Microsoft.VisualBasic.Interaction]::InputBox("Combien d'étendues souhaitez-vous créer ?", "Ajout d'étendue", "")

for ($i = 1; $i -le $nombreEtendues; $i++) {
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
    Write-Host -ForegroundColor Yellow @"
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
                    Ajouter ? (y/n)
"@ 

    # Demander la confirmation de l'utilisateur
    $confirmation = [string](Read-Host)

    if ($confirmation -eq "y") {
        Write-Output "Ajout de l'étendue en cours ..."
        try {
            # Créer l'étendue DHCP
            Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premierAdd -EndRange $dernierAdd -SubnetMask $masqueReseau -State Active
            Set-DhcpServerv4OptionValue -OptionID 3 -Value $passerelle -ScopeID $reseauAdd
            Set-DhcpServerv4OptionValue -DnsDomain $nomDNS -DnsServer $dnsAdd
            Write-Output "L'étendue a été ajoutée avec succès."
        } catch {
            Write-Output "Erreur lors de l'ajout de l'étendue : $_"
        }

        # Demander si l'utilisateur souhaite ajouter des réservations d'adresses
        $ajouterReservations = [Microsoft.VisualBasic.Interaction]::InputBox("Souhaitez-vous ajouter des réservations d'adresses ? (y/n)", "Réservations d'adresses", "")

        if ($ajouterReservations -eq "y") {
            $nombreReservations = [int][Microsoft.VisualBasic.Interaction]::InputBox("Combien de réservations souhaitez-vous ajouter ?", "Réservations d'adresses", "")

            for ($j = 1; $j -le $nombreReservations; $j++) {
                $adresseIP = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse IP de la réservation", "Réservations d'adresses", "")
                $nomClient = [Microsoft.VisualBasic.Interaction]::InputBox("Nom du client", "Réservations d'adresses", "")
                $macAddress = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse MAC du client", "Réservations d'adresses", "")

                try {
                    Add-DhcpServerv4Reservation -ScopeId $reseauAdd -IPAddress $adresseIP -ClientId $macAddress -Name $nomClient
                    Write-Output "Réservation ajoutée avec succès pour $nomClient."
                } catch {
                    Write-Output "Erreur lors de l'ajout de la réservation : $_"
                }
            }
        }
    } else {
        Write-Output "Opération annulée par l'utilisateur."
        exit
    }
}
