#include "otpch.h"

#include "titles.h"

#include "pugicast.h"
#include "tools.h"

bool Titles::reload()
{
	titles.clear();
	return loadFromXml();
}

bool Titles::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/titles.xml");
	if (!result) {
		printXMLError("Error - Wings::loadFromXml", "data/XML/titles.xml", result);
		return false;
	}

	for (auto titleNode : doc.child("titles").children()) {
		titles.emplace_back(
			static_cast<uint8_t>(pugi::cast<uint16_t>(titleNode.attribute("id").value())),
			titleNode.attribute("name").as_string(),
			titleNode.attribute("color").as_string(),
			titleNode.attribute("premium").as_bool()
		);
	}
	titles.shrink_to_fit();
	return true;
}

Title* Titles::getTitleByID(uint8_t id)
{
	auto it = std::find_if(titles.begin(), titles.end(), [id](const Title& title) {
		return title.id == id;
		});

	return it != titles.end() ? &*it : nullptr;
}

Title* Titles::getTitleByName(const std::string& name) {
	auto titleName = name.c_str();
	for (auto& it : titles) {
		if (strcasecmp(titleName, it.name.c_str()) == 0) {
			return &it;
		}
	}

	return nullptr;
}
