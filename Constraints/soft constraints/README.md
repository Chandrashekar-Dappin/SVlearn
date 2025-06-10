## By default constraints are hard constraints. they cannot be overridden or conflicted.

## In normal case if we write in-line constraint with normal constraint it will be added to it if they are in common range. if they are conf;icted randomization won't happen.

## Soft constraint : in this case,in-line constraints will override the existing constraints.

## Ex: constraint c1 { soft addr>100; addr<200; }  // 'soft' keyword is used.

## Ex:
