
function [vector_senial_recortado] = recorte_tiempo(vector_senial, tiempo_inicial, tiempo_final,fm)
Frame_inicial = round(tiempo_inicial*fm);
if(Frame_inicial == 0)
    Frame_inicial = 1;
end
Frame_final = round(tiempo_final*fm);
if(Frame_final == 0)
    Frame_final = 1;
end
vector_senial_recortado = vector_senial(Frame_inicial:Frame_final);
end