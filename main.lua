
largura = love.graphics.getWidth()
altura = love.graphics.getHeight()

function love.load()
  imgCarro = love.graphics.newImage( "car.png" )
  background = love.graphics.newImage("background.png")
  carro = {
    posX = largura /2,
    posY = altura -80,
    angulo = 0
  }

    -- Pausa
    pausar = false
    imgPausar = love.graphics.newImage("pausar.png")
    imgResumir = love.graphics.newImage("resumir.png")
    imgSair = love.graphics.newImage("sair.png")
    imgMenu = love.graphics.newImage("menu.png")

    -- Inimigos
    delayInimigo = 70
    nivel = 1
    velo = 150
    imgInimigo = love.graphics.newImage("1.png")
    tempoCriarInimigo = delayInimigo
    inimigos = {}


    --Tela caindo
    valTela = 360
    valTempo = 7.8
    delayImg = 800
    tempoCriarImg = delayImg
    imagens = {}

    -- Pontos
    estadoVivo = true
    pontos = 0
    mouseX = 0
    mouseY = 0
end

function love.update ( dt )
  if not pausar then
    mover( dt )
    inimigo( dt )
    tela( dt )
    colisoes()
    cliques( dt )
  end

  pause(dt)
  menu(dt)

  if not estadoVivo and (love.keyboard.isDown( 'r' ) or love.mouse.isDown( '1' )) then
    inimigos = {}
    imagens = {}
    tempoCriarInimigo = delayInimigo
    tempoCriarImg = delayImg
    carro.posX = largura /2
    carro.posy = altura -80
    carro.angulo = 0
    pontos = 0
    estadoVivo = true
    nivel = 1
    velo = 150
    valTela = 360
    valTempo = 7.8
  end
end

function love.draw ()
  -- Carro
  angulo = carro.angulo
  --love.graphics.draw(background, largura /2, altura / 2, 0, 1, 1, background:getWidth()/2, background:getHeight()/2)
  for i, imagem in ipairs(imagens) do
    love.graphics.draw(imagem.img, imagem.x, imagem.y, 0, 1, 1, imagem.img:getWidth()/2, imagem.img:getHeight()/2)
  end

  if estadoVivo then
    love.graphics.draw(imgCarro, carro.posX, carro.posY, angulo, 1, 1, imgCarro:getWidth()/2, imgCarro:getHeight()/2)
    love.graphics.print("pontos -> " .. pontos, 10, 50)
    love.graphics.print("velocidade -> " .. string.format("%.1f", velo/3.5) .. "km", 10, 70)
  else
    love.graphics.print("CLIQUE NA TELA PARA REVIVER \n PONTOS -> " .. pontos, largura/2.5, altura/2)
  end
  -- Inimigos
  for i, inimigo in ipairs(inimigos) do
    love.graphics.draw(inimigo.img, inimigo.x, inimigo.y, 0)
  end

  love.graphics.draw(imgSair, 795, 280, 0, 1, 1, imgSair:getWidth(), imgSair:getHeight())

  if pausar == false then
    love.graphics.draw(imgPausar, 795, 150, 0, 1, 1, imgPausar:getWidth(), imgPausar:getHeight())
  elseif pausar == true then
    love.graphics.draw(imgResumir, 795, 150, 0, 1, 1, imgResumir:getWidth(), imgResumir:getHeight())
    love.graphics.draw(imgMenu, 600, 300, 0, 1, 1, imgMenu:getWidth(), imgMenu:getHeight())

  end


end

function mover ( dt )
  if love.keyboard.isDown('right') then
    if carro.posX < ( largura - imgCarro:getWidth() * 2.1 ) then
      carro.posX = carro.posX + 150 * dt
      carro.angulo = 0.2
    end
  end
  if love.keyboard.isDown('left') then
    if carro.posX > ( 0 + imgCarro:getWidth() * 2.2 ) then
      carro.posX = carro.posX - 150 * dt
      carro.angulo = -0.2
    end
  end
  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    carro.angulo = 0
  end
end

function cliques ( dt )
  if love.mouse.isDown( '1' ) then
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    if (mouseX > 400) and (mouseY > 340) then
      if carro.posX < ( largura - imgCarro:getWidth() * 2.1 ) then
        carro.posX = carro.posX + 150 * dt
        carro.angulo = 0.2
      end
    end
    if (mouseX < 400) and (mouseY > 340) then
      if carro.posX > ( 0 + imgCarro:getWidth() * 2.2 ) then
        carro.posX = carro.posX - 150 * dt
        carro.angulo = -0.2
      end
    end
  end
end


function inimigo ( dt )
  tempoCriarInimigo = tempoCriarInimigo - ( nivel - dt )
  if tempoCriarInimigo < 0 then
    tempoCriarInimigo = delayInimigo
    numeroAleatorio = math.random(largura / 4 - 40, largura / 1.35  )
    opImg = math.random(1, 5)
    if opImg == 1  then
      imgInimigo = love.graphics.newImage("1.png")
    elseif opImg == 2 then
      imgInimigo = love.graphics.newImage("2.png")
    elseif opImg == 3 then
      imgInimigo = love.graphics.newImage("3.png")
    elseif opImg == 4 then
      imgInimigo = love.graphics.newImage("4.png")
    elseif opImg == 5 then
      imgInimigo = love.graphics.newImage("5.png")
    end
    novoInimigo = { x = numeroAleatorio, y = -imgInimigo:getWidth(), img = imgInimigo}
    table.insert(inimigos, novoInimigo)
  end
  for i, inimigo in ipairs( inimigos ) do
    inimigo.y = inimigo.y + ( velo * dt )
    if inimigo.y > 850 then
      table.remove( inimigos, i)
      if estadoVivo then
        pontos = pontos + 1
      end
    end
  end
  if valTempo < 800 then
    nivel = nivel + 0.0001000
    velo = velo + 0.05
  end
end

function colisoes (args)
  for i, inimigo in ipairs( inimigos ) do
    if checarColisao(inimigo.x, inimigo.y, imgInimigo:getWidth() / 1.2, imgInimigo:getHeight() / 2, carro.posX - (imgCarro:getWidth() / 2), carro.posY - (imgCarro:getHeight() / 2), imgCarro:getWidth() / 1.2, imgCarro:getHeight() / 2) and estadoVivo then
      estadoVivo = false
    end
  end
end

function checarColisao (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function pause ( dt )
  if love.mouse.isDown('1') then
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
      if (mouseX > 695 and mouseX < 795) and (mouseY > 55 and mouseY < 150) then
         if pausar == false then
           pausar = true
         else
           pausar = false
         end
      end
      if (mouseX > 695 and mouseX < 795) and (mouseY > 230 and mouseY < 330) then
        love.event.quit( )
      end
  end
end

function menu ( dt )
  if love.mouse.isDown('1') then
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    if (mouseX > 520 and mouseX < 580) and (mouseY > 165 and mouseY < 300) and pausar then
      imgCarro = love.graphics.newImage( "car_yellow.png" )
    elseif(mouseX > 430 and mouseX < 490) and (mouseY > 165 and mouseY < 300) and pausar then
      imgCarro = love.graphics.newImage( "car_red.png" )
    elseif(mouseX > 335 and mouseX < 395) and (mouseY > 165 and mouseY < 300) and pausar then
      imgCarro = love.graphics.newImage( "car_black.png" )
    elseif(mouseX > 245 and mouseX < 305) and (mouseY > 165 and mouseY < 300) and pausar then
      imgCarro = love.graphics.newImage( "car_blue.png" )
    elseif(mouseX > 415 and mouseX < 590) and (mouseY > 25 and mouseY < 160) and pausar then
      background = love.graphics.newImage("background.png")
      estadoVivo = false
    elseif(mouseX > 230 and mouseX < 400) and (mouseY > 25 and mouseY < 160) and pausar then
      background = love.graphics.newImage("background-1.png")
      estadoVivo = false
    end
  end
end

function tela ( dt )
  if next(imagens) == nil then
    novaImagem = { x = 400, y = background:getWidth()/4+10, img = background}
    table.insert(imagens, novaImagem)
    tempoCriarImg = 0
  else
    tempoCriarImg = tempoCriarImg - valTempo
  end
  if tempoCriarImg < 0 then
    tempoCriarImg = delayImg
    novaImagem = { x = 400, y = -background:getWidth()/2, img = background}
    table.insert(imagens, novaImagem)
  end
  for i, imagem in ipairs( imagens ) do
    imagem.y = imagem.y + ( valTela * dt )
    if imagem.y > 910 then
      table.remove( imagens, i)
    end
  end
  if valTempo < 800 then
    valTela = valTela + 0.05
    valTempo = (valTela * valTempo) / (valTela - 0.051)
  end
end
