%% Fonction permettant de calculer le torques gravitaire et le torque d'acc�l�ration en reprenant la m�thode utilis�e par Gentili et al., 2007.
%Les param�tres suivants doivent �tre d�finis dans le script principal et
%changent pour chaque sujet : masse du bras, distance centre de rotation de
%l'�paule-centre de masse du bras, moment d'inertie du bras

% function [Torque] = gettorques(position_doigt, position_epaule, gvalue, masse_bras, dist_cdr_cdm, moment_inertie_bras)

Torque = {};

position_doigt = C3D.Cinematique.Donnees(:, 17:19);
position_epaule = C3D.Cinematique.Donnees(:, 1:3);
gvalue = 9.81;
masse_bras = 3.85;
dist_cdr_cdm = 0.33;
moment_inertie_bras = masse_bras*(0.33)^2;

% On calcule la position angulaire du bras � chaque instant

[size_pos, ~] = size(position_doigt);

for f = 1:size_pos
    
   lgbras = sqrt((position_doigt(f, 1)-position_epaule(f, 1))^2+(position_doigt(f, 2)-position_epaule(f, 2))^2+(position_doigt(f, 3)-position_epaule(f, 3))^2);
   verticale = sqrt((position_epaule(f, 1)-position_epaule(f, 1)).^2+(position_epaule(f, 2)-position_epaule(f, 2)).^2+(position_epaule(f, 3)-position_doigt(f, 3)).^2);
   
   pos_angulaire = acos(verticale/lgbras);
   
   Torque.pos_angulaire(f, 1) = pos_angulaire;
end

Torque.accel_angulaire = derive(Torque.pos_angulaire, 2);
% On calcule l'angle entre le bras et la verticale � chaque instant
[size_pos, ~] = size(position_doigt);

for f = 1:size_pos
    
   lgbras = sqrt((position_doigt(f, 2)-position_epaule(f, 2))^2+(position_doigt(f, 3)-position_epaule(f, 3))^2);
   proj_horiz_bras = sqrt((position_doigt(f, 2)-position_epaule(f, 2)).^2);
   
   angle_bras_horizontale = acos(proj_horiz_bras/lgbras);
   
   Torque.angle_bras_horizontale(f, 1) = angle_bras_horizontale;
end

Torque.SGT = masse_bras*dist_cdr_cdm*gvalue*cos(Torque.angle_bras_horizontale);
Torque.SIT = moment_inertie_bras*Torque.accel_angulaire*1000;
Torque.SIT2 = moment_inertie_bras*derive(position_doigt, 2);
                                    T2 = moment_inertie_bras*derive(position_doigt, 2);
