--[[
Nom: Afficher la fenêtre contextuelle À propos de ReArtist
Date: 1 Feb 2024
Auteur: Bing Chat
Indication: Edu Serra www.eduserra.net
]]

-- Définir le message à afficher dans la fenêtre contextuelle
local message = "ReArtist 2.0\n\nDate: 1/02/2024\n\nBonjour, je suis Edu Serra, j'espère que cette configuration vous sera très utile dans vos productions et qu'à travers elle vous pourrez exploiter Reaper au maximum.\n\nReArtist n'aurait pas été possible sans la contribution des programmeurs qui soutiennent en permanence la croissance de ReaPack, SWS Extensions et JSFX Plugins, en apportant leur aide à la communauté via le Forum Officiel. Un grand merci à eux.\n\nÀ partir de cette version 2.0, ReArtist sera gratuit, mais pour qu'il continue ainsi, je dépend du soutien que les utilisateurs peuvent me donner par des dons et/ou l'achat de mes cours, c'est la seule façon pour moi de couvrir les frais de maintenance du site web et le temps que je consacre à développer, maintenir et mettre à jour la configuration.\n\nToute contribution que vous pouvez apporter sera très utile.\n\nCliquez sur \"DONATION\" dans ce menu pour aller à la section des dons de mon site web.\n\nProfitez de ReArtist : “Tout le bon de Reaper”."

-- Afficher la fenêtre contextuelle avec le message
reaper.ShowMessageBox(message, "À propos de ReArtist", 0)

