behaviour("LQS_MultiVehicle")

function LQS_MultiVehicle:Start()
	--Base
	self.data = self.gameObject.GetComponent(DataContainer)
	self.spawnTransform = self.gameObject.transform

	--Bools
	self.stillNoActor = false

	--Probability Stuff
	self.enterChance = Random.Range(1, 100)

	--Entries
	self.foundVehicles = {}

	for _,vehicles in pairs(self.data.GetGameObjectArray("vehicle")) do
		self.foundVehicles[#self.foundVehicles+1] = vehicles 
	end

	--Spawn Vehicle Variant
	local chosenVehicle = self.foundVehicles[math.random(#self.foundVehicles)]

	local spawnedVehicle = GameObject.Instantiate(chosenVehicle, self.spawnTransform.position, self.spawnTransform.rotation)
	self.gameObject.SetActive(false)
end