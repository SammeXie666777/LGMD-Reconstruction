function Check_ZeroLength (swc)
% Check zero-length
% Assume the first two nodes are the soma
seg_leg = zeros(1,length(swc(:,1)) - 1);
zero_nodes = [];

for i = 2:length(swc(:,1))
    x = swc(i,3); 
    y = swc(i,4);
    z = swc(i,5);
    parentID = swc (i,7);
    p_x = swc(parentID,3); 
    p_y = swc(parentID,4); 
    p_z = swc(parentID,5); 
    lg  = sqrt((x-p_x)^2 + (y-p_y)^2 + (z-p_z)^2);
    seg_leg(i-1) = lg; 
    
    if lg <= 1e-3
        fprintf(['Segments include node %d with parent %d are zero length: \n' ...
            '- child: x = %d; y = %d; z = %d \n' ...
            '- child: x = %d; y = %d; z = %d \n' ...
            '- length = %d \n'], i, parentID,x,y,z,p_x,p_y,p_z, lg);
        zero_nodes = [zero_nodes, i];
    end
end


end







