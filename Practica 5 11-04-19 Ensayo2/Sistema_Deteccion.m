function [vector_activos] = Sistema_Deteccion(vector_filtrado,frec_muestreo,duracion_temporal_minima,duracion_temporal_maxima,intervalo_silbido_tiempo)

limite_duracion=round(intervalo_silbido_tiempo*frec_muestreo);
frames_duracion_minima = round(duracion_temporal_minima*frec_muestreo)+1;
frames_duracion_maxima = round(duracion_temporal_maxima*frec_muestreo)+1;

vector_comparado =zeros(size(vector_filtrado));
umbral_alto = 0.006;
umbral_bajo = 0.002;
detectado = false;
contador = 0;
frame_detectado = 0;

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

vector_silbidos = zeros(length(vector_comparado),1);
detectado = false;



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
 
modo_alarma = false;
contador = 0;
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


        

