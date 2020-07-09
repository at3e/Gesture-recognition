function Et = TEO(y)
dydt = diff (y);
dydt = vertcat (dydt(1,:),dydt);
d2ydt2 = diff(dydt);
d2ydt2 = vertcat (d2ydt2(1,:),d2ydt2);

Et = dydt.^2 - y.*d2ydt2;
end