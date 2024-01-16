function [POS_ANGULAIRE] = pos_angulaire2(position_doigt, position_epaule)

[size_pos, ~] = size(position_doigt);
POS_ANGULAIRE = zeros(size_pos, 1);
for f = 1:size_pos
    
   lgbras = sqrt((position_epaule(f, 1)-position_doigt(f, 1))^2+(position_epaule(f, 2)-position_doigt(f, 2))^2+(position_epaule(f, 3)-position_doigt(f, 3))^2);
   verticale = sqrt((position_epaule(f, 1)-position_epaule(f, 1)).^2+(position_epaule(f, 2)-position_epaule(f, 2)).^2+(position_epaule(f, 3)-position_doigt(f, 3)).^2);
   
   pos_angulaire = atan2(lgbras, verticale);
   
   POS_ANGULAIRE(f, 1) = pos_angulaire;
end