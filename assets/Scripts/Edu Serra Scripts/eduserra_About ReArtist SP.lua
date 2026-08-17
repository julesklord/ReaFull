--[[
Nombre: Mostrar ventana emergente Acerca de ReArtist
Fecha: 1 Feb 2024
Autor: Bing Chat
Indicación: Edu Serra www.eduserra.net
]]

-- Definir el mensaje para mostrar en la ventana emergente
local message = "ReArtist 2.0\n\nFecha: 1/02/2024\n\nHola, soy Edu Serra, espero que esta configuración te sea de mucha ayuda en tus producciones y a través de ella puedas explotar Reaper al máximo.\n\nReArtist no habría sido posible sin la contribución de los programadores que apoyan permanentemente el crecimiento de ReaPack, SWS Extensions y JSFX Plugins, brindando ayuda a la comunidad a través del Foro Oficial. Un gran agradecimiento para ellos.\n\nA partir de esta versión 2.0 ReArtist será gratuita, pero para que continúe así, dependo del apoyo que los usuarios me puedan dar a través de donaciones y/o de la compra de mis cursos, sólo así podré solventar los gastos de mantenimiento del website y del tiempo que dedico a desarrollar, mantener y actualizar la configuración.\n\nCualquier aporte que puedas hacer será de mucha ayuda.\n\nHaz click en \"DONATION\" en este menú para ir a la sección de donaciones de mi website.\n\nDisfruta de ReArtist: “Todo lo bueno de Reaper”."

-- Mostrar la ventana emergente con el mensaje
reaper.ShowMessageBox(message, "Acerca de ReArtist", 0)

