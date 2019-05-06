% Resumen: Etapa de comparacion de un vector filtrado para obtener la
% alarma
% Recibe; vector ya filtrado, frecuencia de muestreo, duracion maxima y 
% minima de silbidos, intervalo de tiempo entre silbidos consecutivos

function [vector_activos] = Sistema_Deteccion(vector_filtrado,frec_muestreo,...
    duracion_temporal_minima,duracion_temporal_maxima,intervalo_silbido_tiempo)

%................... COMPARACION
%  Da alto cada vez que la senial pasa un primer umbral(alto) de deteccion y
%  luego pasa a bajo una vez que pasó un segundo umbral (bajo). Permite ver
%  la duracion de cada silbido

vector_comparado = zeros(size(vector_filtrado));
umbral_alto = 0.006;
umbral_bajo = 0.001;
detectado = false; % Para cambiar el umbral adaptativo


for i=1:length(vector_filtrado)
    if (detectado == false)
        if (vector_filtrado(i)>umbral_alto)
            vector_comparado(i) = 0.1;
            detectado = true;
        else
            vector_comparado(i) = 0;
        end
    else
            if (vector_filtrado(i)<umbral_bajo)
            vector_comparado(i) = 0;
            detectado = false;
            else
            vector_comparado(i) = 0.1;
            end
    end
end

%................... VALIDACION DE SILBIDO
% Se valida si los silbidos medidos que pasaron las anteriores condiciones
% cumplen con condiciones de tiempo dadas

vector_silbidos = zeros(length(vector_comparado),1);

% transformamos los tiempos en frames para poder trabajarlos
frames_duracion_minima = round(duracion_temporal_minima*frec_muestreo)+1;
frames_duracion_maxima = round(duracion_temporal_maxima*frec_muestreo)+1;

detectado = false; % Por si esta en alto o en bajo
contador = 0; % Cuenta el tiempo en alto
frame_detectado = 0; % Memoriza el lugar donde empieza el silbido

for j=1:length(vector_silbidos)
    if(detectado == false)
        if(vector_comparado(j) > 0)
            detectado = true;
            frame_detectado = j;
        end
    else
        if(vector_comparado(j) == 0)
            detectado = false;
            if((contador >= frames_duracion_minima) && ...
                    (contador < frames_duracion_maxima))
                vector_silbidos(frame_detectado) = 1;
            end
                contador = 0;  
            
        else
            contador = contador + 1;
        end
    end
end           

%................... ACTIVACION DE LA ALARMA
% Indica en que tiempos la alarma debe activarse. Para la activacion de la
% alarma, el primer silbido detectado determina el incio de la alarma.
% Para desactivarla, se tiene que determinar silbidos consecutivos. Se
% establecio que un silbido es consecutivo si no pasan mas del limite
% establecido en "limite_duracion"

% transformamos los tiempos en frames para poder trabajarlos
limite_duracion=round(intervalo_silbido_tiempo*frec_muestreo);

modo_alarma = false; % Si esta la alarma prendida o no
contador = 0;% cuenta los silbidos consecutivos

% contador_frames cuenta los frames desde que la alarma esta activa, para
% determinar si cumple el limite o no
contador_frames=0;

vector_activos = zeros(length(vector_comparado),1);

for i=1:length(vector_silbidos)
    
    if(modo_alarma == false)
        if(vector_silbidos(i) > 0)
            modo_alarma = true;
            vector_activos(i) = 1;
        end
    else
        contador_frames=contador_frames+1;
        
        if(contador_frames > limite_duracion)
            contador=0;
        end
   
        if(contador == 3)
            modo_alarma = false;
            contador_frames=0;
            contador = 0;
             vector_activos(i) = -1;
        else
            if(vector_silbidos(i) > 0 )
            contador = contador + 1;
            contador_frames=0;
            end
        end
    end
end

%...................... Graficacion
num_muestras = length(vector_filtrado);
vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
tamanio_titulo = 22;
tamanio_ejes  = 18;

figure ('Color',[1 1 1],'Name','Señales','NumberTitle','off');
subplot(3,1,1);
plot(vector_tiempo, vector_comparado,'LineWidth',1,'Color','g');grid on;

title('Señal Comparada','FontSize',tamanio_titulo,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',tamanio_ejes,'FontName','Arial')
ylabel('Amplitud','FontSize',tamanio_ejes,'FontName','Arial')

subplot(3,1,2);
plot(vector_tiempo, vector_silbidos,'LineWidth',1,'Color','r');grid on;

title('Señal de Silbidos','FontSize',tamanio_titulo,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',tamanio_ejes,'FontName','Arial')
ylabel('Amplitud','FontSize',tamanio_ejes,'FontName','Arial')

subplot(3,1,3);
plot(vector_tiempo, vector_activos,'LineWidth',1,'Color','b');grid on;  

title('Señal de activacion','FontSize',tamanio_titulo,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',tamanio_ejes,'FontName','Arial')
ylabel('Amplitud','FontSize',tamanio_ejes,'FontName','Arial')


        

