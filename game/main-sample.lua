
-- Include the library
local boner = require 'boner'

local myActor;
function love.load()
	-- Create the skeleton.
	local mySkeleton = boner.newSkeleton();
	
	-- Add bones to the skeleton
	local boneLength = 50;
	local boneName = "bone";
	for i = 1, 10 do
		local name = boneName .. i;
		local parent = boneName .. (i - 1);
		if (i == 1) then
			parent = nil; -- The first bone is the "root", so it shouldn't have a parent.
		end
		local offset = {boneLength, 0};
		if (i == 1) then
			offset[1] = 0; -- The first bone is the "root", so it doesn't need an offset.
		end
		local rotation = 0;
		local translation = {0, 0};
		local scale = {1, 1};
		local bone = boner.newBone(name, parent, i, offset, rotation, translation, scale);
		mySkeleton:AddBone(bone);
	end
	
	-- Validate the skeleton!
	mySkeleton:Validate();
	
	-- Create an animation.
	local myAnimation = boner.newAnimation("curl", mySkeleton);
	for i = 1, 10 do
		local name = boneName .. i;
		myAnimation:AddKeyFrame(name, 2, math.rad(5*i), nil, nil);
		myAnimation:AddKeyFrame(name, 2.5, math.rad(0), nil, nil);
		myAnimation:AddKeyFrame(name, 4.5, -math.rad(5*i), nil, nil);
		myAnimation:AddKeyFrame(name, 5, math.rad(0), nil, nil);
	end
	
	-- Create an actor.
	myActor = boner.newActor(mySkeleton);
	
	-- Create the visual elements for the actor
	local boneVisuals = {};
	for i = 1, 10 do
		local name = boneName .. i;
		local imageData = love.image.newImageData(boneLength, 20);
		imageData:mapPixel(function(x, y, r, g, b, a) 
			local hasRed = (i % 3) == 0;
			local hasGreen = (i % 3) == 1;
			local hasBlue = (i % 3) == 2;
			if (hasRed) then r = 255; end
			if (hasGreen) then g = 255; end
			if (hasBlue) then b = 255; end
			return r, g, b, 255;
		end);
		boneVisuals[i] = boner.newVisual(imageData);
		local vw, vh = boneVisuals[i]:GetDimensions();
		boneVisuals[i]:SetOrigin(0, vh/2);
	end
	
	-- Add attachments to the actor using the visual elements.
	for i = 1, 10 do
		local name = boneName .. i;
		local myAttachment = boner.newAttachment(boneVisuals[i]);
		myActor:SetAttachment(name, "skin", myAttachment);
	end
	
	-- Register the animation as a transformation.
	myActor:GetTransformer():Register("anim_curl", myAnimation, mySkeleton:GetBoneTree("bone1"));
	
	-- Move it toward the center and stand it upright.
	myActor:GetTransformer():GetRoot().rotation = math.rad(-90);
	myActor:GetTransformer():GetRoot().translation = {love.graphics.getWidth() / 2, love.graphics.getHeight() / 1.25};
end

-- Call the Draw and Update methods.
function love.draw()
	myActor:Draw();
end
function love.update(dt)
	myActor:Update(dt);
end

-- Tell the animation to start.
function love.keypressed(key, isRepeat)
	if (key == ' ') then
		myActor:Start();
		myActor:GetTransformer():SetPower("anim_curl", 1);
	end
end