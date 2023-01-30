local spectating = false

-- Función para espectar a un jugador aleatorio
function SpectateRandomPlayer()
  -- Obtiene una lista de todos los jugadores en el juego
  local players = GetPlayers()

  -- Selecciona un jugador aleatorio
  local target = players[math.random(#players)]

  -- Obtiene el ID del PED del jugador objetivo
  local targetPed = GetPlayerPed(target)

  -- Obtiene las coordenadas del PED del jugador objetivo
  local targetCoords = GetEntityCoords(targetPed)

  -- Solicita colisión en las coordenadas del jugador objetivo
  RequestCollisionAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)

  -- Activa el modo espectador
  NetworkSetInSpectatorMode(true, targetPed)
end

-- Comando para activar y desactivar el espectador automático
RegisterCommand("spectate", function(source, args)
  spectating = not spectating

  if spectating then
    SpectateRandomPlayer()

    Citizen.CreateThread(function()
      while spectating do
        Citizen.Wait(15000)
        SpectateRandomPlayer()
      end
    end)

    print("Espectador automático activado.")
  else
    NetworkSetInSpectatorMode(false, nil)

    print("Espectador automático desactivado.")
  end
end)
