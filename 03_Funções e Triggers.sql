create or replace function fn_baixa_estoque()
RETURNS trigger as $$
declare
	estoque_atual integer;
begin

	select qt_estoque
	into estoque_atual
	from estoque
	where produto_id = NEW.produto_id;

	if estoque_atual < NEW.quantidade then
		raise exception 'estoque insuficiente';
	end if;

	IF estoque_atual IS NULL THEN
		RAISE EXCEPTION 'Produto sem registro de estoque';
	END IF;

	update estoque 
	set qt_estoque = qt_estoque - NEW.quantidade
	where produto_id = NEW.produto_id;

	RETURN NEW;

end;

$$ language plpgsql;

create trigger trg_baixa_estoque
before insert 
on itens_venda
for each row
execute function fn_baixa_estoque();

