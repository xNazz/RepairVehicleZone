--Command to repair
lib.addCommand('repair', {
	help = 'Repair your vehicle inside zone',
}, function(source)
	local src = source
	TriggerClientEvent('nazz:repairzones', src)
end)
