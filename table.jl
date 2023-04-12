using PrettyTables

struct AccountItem
    name:: String
    time:: Integer
    amount::Number
end

struct Account
    name::String
    items::Array{AccountItem}
end

function add_item!(acc::Account, item::AccountItem)
    push!(acc.items, item)
end

struct GodleyRow
    name::String
    time::Number
    amounts::Dict{Account, <:Number}
end

struct GodleyTable
    name::String
    accounts::Array{Account}
    rows::Array{GodleyRow}
end

function add_row!(table::GodleyTable, row:: GodleyRow)
    push!(table.rows, row)
end

function print_godley_table(table::GodleyTable)
    sorted_accounts = sort(table.accounts, by = x -> x.name)
    lines = Array{Any}(undef, length(table.rows), length(sorted_accounts) + 2)
    for i in eachindex(table.rows)
        row = table.rows[i]
        line = map(a -> get(row.amounts, a, 0.0), sorted_accounts)
        line = convert(Array{Any}, line)
        pushfirst!(line, row.name, row.time)
        lines[i, :] = line
    end

    header = map(acc -> acc.name, sorted_accounts)
    pushfirst!(header, "Name", "Time")
    pretty_table(lines, header=header)

end

workersI = Account("Workers I", [])
workersII = Account("Workers II", [])
capitalistsI = Account("Capitalists I", [])
capitalistsII = Account("Capitalists II", [])

table = GodleyTable("Departments I & II", [workersI, workersII, capitalistsI, capitalistsII], [])
add_row!(table,
         GodleyRow(
            "First payment",
            0,
            Dict(workersI => 100, capitalistsII => -100.0)
         )
        )

add_row!(table,
         GodleyRow(
            "Secont payment",
            1,
            Dict(workersII => 50, capitalistsII => -50.0)
         )
        )
print_godley_table(table)
