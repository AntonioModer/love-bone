--[[
	BÖNER: Library for keyframe-based skeletal animations in LÖVE.
	By Samuel Seltzer-Johnston
--]]
-- TODO: Comment everything.
-- TODO: Clean up, make consistent.
-- TODO: Validate everything.
-- TODO: Add more robust start/pause/stop animation methods
-- TODO: Add sprite batching
-- TODO: Add intersection methods for body parts.
-- TODO: Split this into multiple files.
-- TODO: Add events.
-- TODO: Add keyframe rate.
-- TODO: Convert transformations to matrices to make coordinate finding more black-boxy

local SHARED = require("boner.shared");
local newBone = require("boner.bone");
local newSkeleton = require("boner.skeleton");
local newSkin = require("boner.skin");
local newAnimation = require("boner.animation");
local newActor = require("boner.actor");
local newVisual = require("boner.visual");
local newAttachment = require("boner.attachment");
local newTransformer = require("boner.transformer");

-- Enable/disable debug rendering.
local function setDebug(b)
	SHARED.DEBUG = b;
end
local function getDebug()
	return SHARED.DEBUG;
end

-- Return the library.
return {
	setDebug = setDebug,
	getDebug = getDebug;
	newBone = newBone,
	newSkeleton = newSkeleton, 
	newSkin = newSkin,
	newAnimation = newAnimation, 
	newActor = newActor,
	newVisual = newVisual,
	newAttachment = newAttachment,
	newTransformer = newTransformer
};

--[[
Bone

Skeleton
	Bones -> boneList
		boneName -> Bone
	
Animation
	Keyframes -> boneList
		boneName -> frameList
			i -> keyframeData
				time 		: Keyframe time
				rotation	: Rotation from its parent
				translation	: Translation from its parent
				scale		: Scale from its parent
				eventName	: Name of an event to trigger (nothing happens if eventName does not appear in the eventhandler)
				texID		: Texture ID to change this bone to (no changes are made if the current skin does not have a texture of this ID)

Skin
	Textures -> textureList
		texID -> texData
			image
			quad
			origin
			rotation
			scale
	BoneTextures -> boneList
		boneName -> texID
		
EventHandler
	Events -> eventList
		eventName -> callbacks
			i -> callbackFunc

AttachmentHandler
	Attachments -> boneList
		boneName -> attachList
			attachName
		attachName -> attachment
			boneName	: name of bone
			visualData	: texData or actor

Actor
	Skeleton
	Skin
	Animation
	Attachments
	
Actor:ModSkin(boneName, texID)?
--]]