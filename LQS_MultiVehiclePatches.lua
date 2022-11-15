behaviour("LQS_MultiVehiclePatches")

function LQS_MultiVehiclePatches:Start()
	--Base
	self.mainVehicle = self.targets.mainVehicle
	self.vehicle = self.targets.targetVehicle
	self.vehicleScript = self.vehicle.gameObject.GetComponent(Vehicle)

	self.spawnPos = self.vehicle.transform.position
	self.spawnRot = self.vehicle.transform.rotation

	--Bools
	self.stillNoActor = false
	self.hasActor = false

	--Probability Stuff
	self.enterChance = Random.Range(1, 100)

	--Respawn Stuff
	self.dieTime = 15
	self.dieTimer = 0

	self.alreadyRespawned = false

	--Enter Vehicle
	local chosenSquad = nil
	local nearbyDist = 20
	local currentDist = nil

	local actorsInRange = ActorManager.AliveActorsInRange(self.vehicle.transform.position, 30)

	if (#actorsInRange > 0) then
		for _,actor in pairs(actorsInRange) do
			currentDist = (actor.transform.position - self.vehicle.transform.position).magnitude

			if (not actor.isPlayer) then
				if (not actor.squad.hasPlayerLeader) then
					if (currentDist < nearbyDist) then
						nearbyDist = currentDist
						chosenSquad = actor.squad.leader
						break
					end
				end
			end
		end

		if (chosenSquad ~= nil) then
			chosenSquad.EnterVehicle(self.vehicle.gameObject.GetComponent(Vehicle))
			self.stillNoActor = false
		else
			self.stillNoActor = true
		end
	else
		self.stillNoActor = true
	end
end

function LQS_MultiVehiclePatches:LateUpdate()
	self.enterChance = Random.Range(1, 100)
end

function LQS_MultiVehiclePatches:Update()
	--Get the squad in range to enter the vehicle
	if (self.stillNoActor) then
		if (not self.vehicleScript.isDead) then
			local chosenSquad = nil
			local nearbyDist = 20
			local currentDist = nil
		
			local actorsInRange = ActorManager.AliveActorsInRange(self.vehicle.transform.position, 30)
		
			if (#actorsInRange > 0) then
				if (self.enterChance >= 50) then
					for _,actor in pairs(actorsInRange) do
						currentDist = (actor.transform.position - self.vehicle.transform.position).magnitude
			
						if (not actor.isPlayer) then
							if (not actor.squad.hasPlayerLeader) then
								if (currentDist < nearbyDist) then
									nearbyDist = currentDist
									chosenSquad = actor.squad.leader
									break
								end
							end
						end
					end
			
					if (chosenSquad ~= nil) then
						chosenSquad.EnterVehicle(self.vehicleScript)
						self.stillNoActor = false
					else
						self.stillNoActor = true
					end
				end
			else
				self.stillNoActor = true
			end
		end
	end

	--Spawn a new one when it dies
	if (self.vehicleScript.isDead) then
		self.dieTimer = self.dieTimer + 1 * Time.deltaTime
		if (self.dieTimer >= self.dieTime) then
			if (not self.alreadyRespawned) then
				self:SpawnNew()
				self.alreadyRespawned = true
			end
		end
	end
end

function LQS_MultiVehiclePatches:SpawnNew()
	GameObject.Instantiate(self.mainVehicle, self.spawnPos, self.spawnRot)
end