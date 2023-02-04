#ifndef FS_TITLES_H
#define FS_TITLES_H

struct Title
{
	Title(uint8_t id, std::string name, std::string color, bool premium) :
		name(std::move(name)), color(std::move(color)), id(id), premium(premium) {}

	std::string name;
	std::string color;
	uint8_t id;
	bool premium;
};

class Titles
{
public:
	bool reload();
	bool loadFromXml();
	Title* getTitleByID(uint8_t id);
	Title* getTitleByName(const std::string& name);

	const std::vector<Title>& getTitles() const {
		return titles;
	}

private:
	std::vector<Title> titles;
};

#endif
