module MigrationExt
  def add_unique_constraint(table_name, *columns)
    prefix = ActiveRecord::Base.table_name_prefix
    suffix = ActiveRecord::Base.table_name_suffix
    add_constraint_statements = columns.collect do |column|
      "ADD CONSTRAINT #{unique_constraint_name(table_name, column)} UNIQUE (#{column})"
    end
    table_name = table_name.to_s =~ /#{prefix}(.+)#{suffix}/ ? $1 : table_name.to_s
    execute <<-SQL
      ALTER TABLE #{table_name}
        #{add_constraint_statements.join(",")}
    SQL
  end

  def drop_unique_constraint(table_name, *columns)
    prefix = ActiveRecord::Base.table_name_prefix
    suffix = ActiveRecord::Base.table_name_suffix
    drop_constraint_statements = columns.collect do |column|
      "DROP CONSTRAINT #{unique_constraint_name(table_name, column)}"
    end
    table_name = table_name.to_s =~ /#{prefix}(.+)#{suffix}/ ? $1 : table_name.to_s
    execute <<-SQL
      ALTER TABLE #{table_name}
        #{drop_constraint_statements.join(",")}
    SQL
  end

  private

  def unique_constraint_name(table_name, column)
    "unique_constraint_#{table_name}_on_#{column}"
  end
end

ActiveRecord::Migration.send(:include, MigrationExt)
