%% Fonction permettant de calculer le torques gravitaire et le torque d'accélération en reprenant la méthode utilisée par Gentili et al., 2007.
%Les paramètres suivants doivent être définis dans le script principal et
%changent pour chaque sujet : masse du bras, distance centre de rotation de
%l'épaule-centre de masse du bras, moment d'inertie du bras

 function [Torque] = gettorques2(position_doigt, position_epaule, gvalue, masse_bras, dist_cdr_cdm, debut, fin)

Torque = {};

[size_pos, ~] = size(position_doigt);

% Torque.accel_angulaire = accel_angulaire(debut:fin);
% On calcule l'angle entre le bras et la verticale à chaque instant

for f = 1:size_pos
    
   lgbras = sqrt((position_doigt(f, 2)-position_epaule(f, 2))^2+(position_doigt(f, 3)-position_epaule(f, 3))^2);
   proj_horiz_bras = sqrt((position_doigt(f, 2)-position_epaule(f, 2)).^2);
   
   angle_bras_horizontale = acos(proj_horiz_bras/lgbras);
   
   Torque.angle_bras_horizontale(f, 1) = angle_bras_horizontale;
end
Torque.cosangle = cos(Torque.angle_bras_horizontale);
Torque.SGT = masse_bras*dist_cdr_cdm*gvalue*Torque.cosangle(debut:fin);
% Torque.SIT = moment_inertie_bras*Torque.accel_angulaire*1000;
% Torque.SIT2 = position_doigt;
% Torque.SIT2 = derive(Torque.SIT2, 1);
% Torque.SIT2 = derive(Torque.SIT2, 1);
% Torque.SIT2 = Torque.SIT2*moment_inertie_bras;
